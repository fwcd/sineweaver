//
//  Synthesizer.swift
//  Sineweaver
//
//  Created on 20.11.24
//

@preconcurrency import AVFoundation
import CoreAudio
import Combine
import Foundation

final class Synthesizer: ObservableObject, Sendable {
    private let engine: AVAudioEngine
    
    let model = Mutex(wrappedValue: SynthesizerModel())
    let isDirty = Mutex(wrappedValue: true)

    init() throws {
        engine = AVAudioEngine()
        
        Task { @MainActor in
            model.onChange = { [unowned self] in
                isDirty.lock().wrappedValue = true
                objectWillChange.send()
            }
        }
        
        let mainMixer = engine.mainMixerNode
        let outputNode = engine.outputNode
        
        let outputFormat = outputNode.inputFormat(forBus: 0)
        let sampleRate = outputFormat.sampleRate
        
        let inputFormat = AVAudioFormat(
            commonFormat: outputFormat.commonFormat,
            sampleRate: outputFormat.sampleRate,
            channels: 1,
            interleaved: outputFormat.isInterleaved
        )
        
        // Only used on the audio thread
        var buffers: SynthesizerModel.Buffers?
        var context = SynthesizerContext(frame: 0, sampleRate: sampleRate)

        let srcNode = AVAudioSourceNode { [unowned self] _, _, frameCount, audioBuffers in
            let frameCount = Int(frameCount)
            let model = self.model.lock().wrappedValue
            
            // Reallocate buffers when model changes
            if (buffers?.output.count ?? -1) < frameCount || isDirty.lock().wrappedValue {
                print("(Re)allocating synthesizer buffers...")
                buffers = model.makeBuffers(frameCount: frameCount)
                isDirty.lock().wrappedValue = false
            }
            
            model.render(using: &buffers!, context: context)

            let audioBuffers = UnsafeMutableAudioBufferListPointer(audioBuffers)
            for i in 0..<frameCount {
                for audioBuffer in audioBuffers {
                    let audioBuffer = UnsafeMutableBufferPointer<Float>(audioBuffer)
                    audioBuffer[i] = Float(buffers!.output[i])
                }
            }
            
            context.frame += frameCount

            return noErr
        }
        
        engine.attach(srcNode)
        engine.connect(srcNode, to: mainMixer, format: inputFormat)
        engine.connect(mainMixer, to: outputNode, format: outputFormat)

        print("Starting engine")
        try engine.start()
    }
    
    // TODO: Remove this
    static func amplitude(at frame: Float, frequency: Float, sampleRate: Float) -> Float {
        sin(2 * .pi * frame / sampleRate * frequency)
    }
}
