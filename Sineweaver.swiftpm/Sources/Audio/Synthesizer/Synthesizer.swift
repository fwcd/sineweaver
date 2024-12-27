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

final class Synthesizer: @unchecked Sendable {
    private let engine: AVAudioEngine
    
    @MainActor var model = SynthesizerModel() {
        didSet {
            Task {
                audioModel = model
                isDirty = true
            }
        }
    }
    
    // State shared with the audio thread
    @Mutex private var audioModel = SynthesizerModel()
    @Mutex private var isDirty = true

    init() throws {
        engine = AVAudioEngine()
        
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
            let model = self.audioModel
            
            // Reallocate buffers when model changes
            if (buffers?.output.count ?? -1) < frameCount || isDirty {
                print("(Re)allocating synthesizer buffers...")
                buffers = model.makeBuffers(frameCount: frameCount)
                isDirty = false
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
