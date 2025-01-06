//
//  MixerNode.swift
//  Sineweaver
//
//  Created on 22.11.24
//

/// A node that aggregates its inputs in some form.
struct MixerNode: SynthesizerNodeProtocol {
    enum Operation: Hashable, Codable {
        /// Adds the signals together. Corresponds to basic mixing.
        case sum
        /// Multiplies the signals together. Corresponds to amplitude modulation.
        case product
        
        var neutral: Double {
            switch self {
            case .sum: 0
            case .product: 1
            }
        }
        
        func apply(_ lhs: Double, _ rhs: Double) -> Double {
            switch self {
            case .sum: lhs + rhs
            case .product: lhs * rhs
            }
        }
    }
    
    var operation: Operation = .sum
    
    func render(inputs: [SynthesizerNodeInput], output: inout [Double], state: inout Void, context: SynthesizerContext) -> Bool {
        for i in 0..<output.count {
            output[i] = operation.neutral
            for input in inputs {
                output[i] = operation.apply(output[i], input.buffer[i])
            }
        }
        return true
    }
}
