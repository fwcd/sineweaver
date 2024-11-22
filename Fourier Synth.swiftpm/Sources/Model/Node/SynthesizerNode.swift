//
//  SynthesizerNode.swift
//  Fourier Synth
//
//  Created on 22.11.24
//

/// A processing node.
enum SynthesizerNode: SynthesizerNodeProtocol {
    case sine(SineNode)
    
    func render(inputs: [[Double]], output: inout [Double], context: SynthesizerContext) {
        switch self {
        case let .sine(node): node.render(inputs: inputs, output: &output, context: context)
        }
    }
}
