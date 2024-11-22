//
//  SineNode.swift
//  Fourier Synth
//
//  Created on 22.11.24
//

import Foundation

struct SineNode: SynthesizerNodeProtocol {
    var frequency: Double = 440
    
    func render(buffer: UnsafeMutableBufferPointer<Float>, context: SynthesizerContext) {
        for i in 0..<buffer.count {
            buffer[i] = Float(sin(2 * .pi * context.frame / context.sampleRate * frequency))
        }
    }
}
