//
//  Synthesizer.swift
//  Fourier Synth
//
//  Created on 20.11.24
//

@preconcurrency import AVFoundation
import CoreAudio
import Combine
import Foundation

final class Synthesizer: ObservableObject, Sendable {
    private let engine: AVAudioEngine
    
    nonisolated(unsafe) var model: Mutex<Dirtyable<SynthesizerModel>>!

    init() throws {
        engine = AVAudioEngine()
        model = Mutex(
            wrappedValue: Dirtyable(
                wrappedValue: SynthesizerModel(),
                isDirty: true
            ),
            onChange: { [unowned self] in
                Task { @MainActor in
                    objectWillChange.send()
                }
            }
        )
        
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
        var buffers: SynthesizerModel.Buffers!
        var context = SynthesizerContext(frame: 0, sampleRate: sampleRate)

        let srcNode = AVAudioSourceNode { _, _, frameCount, audioBuffers in
            let frameCount = Int(frameCount)
            var model = self.model.lock().wrappedValue
            
            // Reallocate buffers when model changes
            if model.isDirty {
                print("(Re)allocating synthesizer buffers...")
                buffers = model.wrappedValue.makeBuffers(frameCount: frameCount)
                model.isDirty = false
            }
            
            model.wrappedValue.render(using: &buffers!, context: context)

            let audioBuffers = UnsafeMutableAudioBufferListPointer(audioBuffers)
            for i in 0..<frameCount {
                for audioBuffer in audioBuffers {
                    let audioBuffer = UnsafeMutableBufferPointer<Float>(audioBuffer)
                    audioBuffer[i] = Float(buffers!.output[i])
                }
            }
            
            context.frame += frameCount
            self.model.lock().wrappedValue = model

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
