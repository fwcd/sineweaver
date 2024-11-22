//
//  SynthesizerNode.swift
//  Fourier Synth
//
//  Created on 22.11.24
//

/// A processing node.
enum SynthesizerNode: SynthesizerNodeProtocol {
    case sine(SineNode)
    case mixer(MixerNode)
    case silence(SilenceNode)
    
    func render(inputs: [[Double]], output: inout [Double], context: SynthesizerContext) {
        switch self {
        case let .sine(node): node.render(inputs: inputs, output: &output, context: context)
        case let .mixer(node): node.render(inputs: inputs, output: &output, context: context)
        case let .silence(node): node.render(inputs: inputs, output: &output, context: context)
        }
    }
}
