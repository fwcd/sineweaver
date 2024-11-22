//
//  SineNode.swift
//  Fourier Synth
//
//  Created on 22.11.24
//

import Foundation

/// A sine wave generator.
struct SineNode: SynthesizerNodeProtocol {
    var frequency: Double = 440
    
    func render(inputs: [[Double]], output: inout [Double], context: SynthesizerContext) {
        for i in 0..<output.count {
            output[i] = sin(2 * .pi * context.frame / context.sampleRate * frequency)
        }
    }
}
