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
import Synchronization

final class Synthesizer: Sendable {
    private let engine: AVAudioEngine
    
    @MainActor var model = SynthesizerModel() {
        didSet {
            Task {
                let model = model
                let frameCount = frameCount.withLock { $0 }
                audioState.withLock { audioState in
                    model.update(buffers: &audioState.buffers, frameCount: frameCount)
                    model.update(states: &audioState.states)
                    audioState.model = model
                }
            }
        }
    }
    
    private struct AudioState {
        var model: SynthesizerModel = .init()
        var buffers: SynthesizerModel.Buffers = .init()
        var states: SynthesizerModel.States = .init()
    }
    
    // State shared with the audio thread
    private let audioState = Mutex(AudioState())
    private let frameCount = Mutex(0)

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
        var context = SynthesizerContext(frame: 0, sampleRate: sampleRate)
        var lastAudioState = audioState.withLock { $0 }

        let srcNode = AVAudioSourceNode { [unowned self] _, _, frameCount, audioBuffers in
            let frameCount = Int(frameCount)
            
            func render(audioState: inout AudioState) {
                guard audioState.buffers.output.count == frameCount else {
                    self.frameCount.withLock { $0 = frameCount }
                    return
                }
                
                audioState.model.render(using: &audioState.buffers, states: &audioState.states, context: context)
                
                let audioBuffers = UnsafeMutableAudioBufferListPointer(audioBuffers)
                for i in 0..<frameCount {
                    for audioBuffer in audioBuffers {
                        let audioBuffer = UnsafeMutableBufferPointer<Float>(audioBuffer)
                        audioBuffer[i] = Float(audioState.buffers.output[i])
                    }
                }
                
                context.frame += frameCount
            }
            
            let success = self.audioState.withLockIfAvailable { audioState -> Void in
                render(audioState: &audioState)
                lastAudioState = audioState
            } != nil
            
            if !success {
                render(audioState: &lastAudioState)
            }
            
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
