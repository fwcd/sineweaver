//
//  OscillatorNode.swift
//  Sineweaver
//
//  Created on 22.11.24
//

import Foundation

/// A sine wave generator.
struct OscillatorNode: SynthesizerNodeProtocol {
    var wave: Wave = .sine
    var frequency: Double = 440
    
    enum Wave: String, Hashable, Codable, CaseIterable {
        case sine = "Sine"
        case saw = "Saw"
        case square = "Square"
        
        func sample(_ x: Double) -> Double {
            switch self {
            case .sine: sin(2 * .pi * x)
            case .saw: 1 - x.truncatingRemainder(dividingBy: 1)
            case .square: x.truncatingRemainder(dividingBy: 1) < 0.5 ? 0 : 1
            }
        }
    }
    
    func render(inputs: [[Double]], output: inout [Double], context: SynthesizerContext) {
        for i in 0..<output.count {
            output[i] = wave.sample(Double(context.frame + i) / context.sampleRate * frequency)
        }
    }
}
