//
//  LFONode.swift
//  Sineweaver
//
//  Created on 22.11.24
//

import Foundation

/// A sine wave generator.
struct LFONode: SynthesizerNodeProtocol {
    typealias Wave = OscillatorNode.Wave
    
    var wave: Wave = .sine
    var frequency: Double = 0.5
    var volume: Double = 1
    var isActive = false

    func render(inputs: [SynthesizerNodeInput], output: inout [Double], state: inout Void, context: SynthesizerContext) -> Bool {
        for i in 0..<output.count {
            output[i] = wave.sample(Double(context.frame) * frequency / context.sampleRate) * volume
        }
        return isActive
    }
}
