//
//  Synthesizer.swift
//  Fourier Synth
//
//  Created on 20.11.24
//

import AVFoundation
import CoreAudio
import Combine
import Foundation

class Synthesizer: ObservableObject {
    private let engine: AVAudioEngine
    private var phase: Float = 0
    
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
        
        let srcNode = AVAudioSourceNode { [self] _, _, frameCount, buffers in
            let buffers = UnsafeMutableAudioBufferListPointer(buffers)
            let frequency: Float = 440
            let phaseIncrement = (2 * .pi / sampleRate) * frequency
            for frame in 0..<Int(frameCount) {
                for buffer in buffers {
                    let buffer = UnsafeMutableBufferPointer<Float>(buffer)
                    buffer[frame] = sin(Float(phase))
                }
                phase += phaseIncrement
            }
            return noErr
        }
        
        
        
        engine.attach(srcNode)
        engine.connect(srcNode, to: mainMixer, format: inputFormat)
        engine.connect(mainMixer, to: outputNode, format: outputFormat)

        print("Starting engine")
        try engine.start()
        
    }
}
