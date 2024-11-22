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
    
    let model: Mutex<SynthesizerModel> = .init(wrappedValue: .init())

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
        
        // TODO: Remove this example setup and integrate it into the UI instead
        do {
            let model = model.lock()
            
            let sineId = model.wrappedValue.add(node: .sine(.init()))
            model.wrappedValue.outputNodeId = sineId
        }
        
        // Only used on the audio thread
        var buffers: SynthesizerModel.Buffers? = nil
        var context = SynthesizerContext(frame: 0, sampleRate: sampleRate)

        let srcNode = AVAudioSourceNode { _, _, frameCount, audioBuffers in
            let frameCount = Int(frameCount)
            let model = self.model.lock().wrappedValue
            
            // TODO: Handle changes in the graph
            if buffers == nil {
                buffers = model.makeBuffers(frameCount: frameCount)
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
