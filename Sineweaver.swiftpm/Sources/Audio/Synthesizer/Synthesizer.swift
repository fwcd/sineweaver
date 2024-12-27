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
                let model = model
                var audioState = audioState
                model.update(buffers: &audioState.buffers, frameCount: frameCount)
                audioState.model = model
                self.audioState = audioState
            }
        }
    }
    
    // State shared with the audio thread
    @Mutex private var audioState = (model: SynthesizerModel(), buffers: SynthesizerModel.Buffers())
    @Mutex private var frameCount: Int = 0

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

        let srcNode = AVAudioSourceNode { [unowned self] _, _, frameCount, audioBuffers in
            let frameCount = Int(frameCount)
            let audioState = $audioState.lock()
            
            if audioState.wrappedValue.buffers.output.count == frameCount {
                audioState.wrappedValue.model.render(using: &audioState.wrappedValue.buffers, context: context)
                
                let audioBuffers = UnsafeMutableAudioBufferListPointer(audioBuffers)
                for i in 0..<frameCount {
                    for audioBuffer in audioBuffers {
                        let audioBuffer = UnsafeMutableBufferPointer<Float>(audioBuffer)
                        audioBuffer[i] = Float(audioState.wrappedValue.buffers.output[i])
                    }
                }
                
                context.frame += frameCount
            } else {
                self.frameCount = frameCount
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
