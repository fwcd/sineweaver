//
//  SilenceNode.swift
//  Sineweaver
//
//  Created on 22.11.24
//

/// A node that emits silence.
struct SilenceNode: SynthesizerNodeProtocol {
    func render(inputs: [[Double]], output: inout [Double], context: SynthesizerContext) {
        for i in 0..<output.count {
            output[i] = 0
        }
    }
}
