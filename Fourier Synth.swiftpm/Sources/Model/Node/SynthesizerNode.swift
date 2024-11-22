//
//  SynthesizerNode.swift
//  Fourier Synth
//
//  Created on 22.11.24
//

enum SynthesizerNode: SynthesizerNodeProtocol {
    case sine(SineNode)
    
    func render(buffer: UnsafeMutableBufferPointer<Float>, context: SynthesizerContext) {
        switch self {
        case let .sine(node): node.render(buffer: buffer, context: context)
        }
    }
}
