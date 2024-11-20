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
    let phase: Mutex<Float> = .init(wrappedValue: 0)
    
    init() throws {
        engine = AVAudioEngine()
        
        let mainMixer = engine.mainMixerNode
        let outputNode = engine.outputNode
        
        let outputFormat = outputNode.inputFormat(forBus: 0)
        let sampleRate = Float(outputFormat.sampleRate)
        
        let inputFormat = AVAudioFormat(
            commonFormat: outputFormat.commonFormat,
            sampleRate: outputFormat.sampleRate,
            channels: 1,
            interleaved: outputFormat.isInterleaved
        )
        
        let srcNode = AVAudioSourceNode { _, _, frameCount, buffers in
            let buffers = UnsafeMutableAudioBufferListPointer(buffers)
            let frequency: Float = 440
            let phaseIncrement = (2 * .pi / sampleRate) * frequency
            var phase = self.phase.lock().wrappedValue
            for frame in 0..<Int(frameCount) {
                for buffer in buffers {
                    let buffer = UnsafeMutableBufferPointer<Float>(buffer)
                    buffer[frame] = sin(Float(phase))
                }
                phase += phaseIncrement
            }
            self.phase.lock().wrappedValue = phase
            return noErr
        }
        
        
        
        engine.attach(srcNode)
        engine.connect(srcNode, to: mainMixer, format: inputFormat)
        engine.connect(mainMixer, to: outputNode, format: outputFormat)

        print("Starting engine")
        try engine.start()
        
    }
}
