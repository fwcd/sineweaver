//
//  LFONode.swift
//  Sineweaver
//
//  Created on 22.11.24
//

import Foundation

/// A low-frequency oscillator that generates a positive signal between 0 and 1.
struct LFONode: SynthesizerNodeProtocol {
    typealias Wave = OscillatorNode.Wave
    
    var wave: Wave = .sine
    var frequency: Double = 1
    var scale: Double = 1
    var isActive = false

    func render(inputs: [SynthesizerNodeInput], output: inout [Double], state: inout Void, context: SynthesizerContext) -> Bool {
        for i in 0..<output.count {
            output[i] = 0.5 + 0.5 * wave.sample(Double(context.frame + i) * frequency / context.sampleRate) * scale
        }
        return isActive
    }
}
