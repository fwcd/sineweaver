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
    
    init() throws {
        engine = AVAudioEngine()
        
        let srcNode = AVAudioSourceNode { _, _, frameCount, buffers in
            let buffers = UnsafeMutableAudioBufferListPointer(buffers)
            for i in 0..<Int(frameCount) {
                for buffer in buffers {
                    let buffer = UnsafeMutableBufferPointer<Float>(buffer)
                    buffer[i] = sin(Float(i) * 0.005)
                }
            }
            return noErr
        }
        
        let mainMixer = engine.mainMixerNode
        let outputNode = engine.outputNode
        
        let outputFormat = outputNode.inputFormat(forBus: 0)
        let inputFormat = AVAudioFormat(
            commonFormat: outputFormat.commonFormat,
            sampleRate: outputFormat.sampleRate,
            channels: 1,
            interleaved: outputFormat.isInterleaved
        )
        
        engine.attach(srcNode)
        engine.connect(srcNode, to: mainMixer, format: inputFormat)
        engine.connect(mainMixer, to: outputNode, format: outputFormat)

        print("Starting engine")
        try engine.start()
        
    }
}
