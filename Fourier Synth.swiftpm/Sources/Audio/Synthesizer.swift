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
    
    let sampleRate: Float
    let frame: Mutex<Int> = .init(wrappedValue: 0)
    let frequency: Mutex<Float> = .init(wrappedValue: 440)

    init() throws {
        engine = AVAudioEngine()
        
        let mainMixer = engine.mainMixerNode
        let outputNode = engine.outputNode
        
        let outputFormat = outputNode.inputFormat(forBus: 0)
        let sampleRate = Float(outputFormat.sampleRate)
        self.sampleRate = sampleRate
        
        let inputFormat = AVAudioFormat(
            commonFormat: outputFormat.commonFormat,
            sampleRate: outputFormat.sampleRate,
            channels: 1,
            interleaved: outputFormat.isInterleaved
        )
        
        let srcNode = AVAudioSourceNode { _, _, frameCount, buffers in
            let buffers = UnsafeMutableAudioBufferListPointer(buffers)
            let frequency = self.frequency.lock().wrappedValue
            var frame = self.frame.lock().wrappedValue
            for i in 0..<Int(frameCount) {
                for buffer in buffers {
                    let buffer = UnsafeMutableBufferPointer<Float>(buffer)
                    buffer[i] = Synthesizer.amplitude(
                        at: Float(frame),
                        frequency: frequency,
                        sampleRate: sampleRate
                    )
                }
                frame += 1
            }
            self.frame.lock().wrappedValue = frame
            return noErr
        }
        
        
        
        engine.attach(srcNode)
        engine.connect(srcNode, to: mainMixer, format: inputFormat)
        engine.connect(mainMixer, to: outputNode, format: outputFormat)

        print("Starting engine")
        try engine.start()
    }
    
    static func amplitude(at frame: Float, frequency: Float, sampleRate: Float) -> Float {
        sin(2 * .pi * frame / sampleRate * frequency)
    }
}
