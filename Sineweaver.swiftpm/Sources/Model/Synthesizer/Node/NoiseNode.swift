//
//  NoiseNode.swift
//  Sineweaver
//
//  Created on 11.01.25
//

import Foundation

/// A white noise generator.
struct NoiseNode: SynthesizerNodeProtocol {
    var volume: Double = 1

    func render(inputs: [SynthesizerNodeInput], output: inout [Double], state: inout Void, context: SynthesizerContext) -> Bool {
        for i in 0..<output.count {
            output[i] = volume > 0 ? Double.random(in: (-volume)..<volume) : 0
        }
        return inputs.first?.isActive ?? false
    }
}
