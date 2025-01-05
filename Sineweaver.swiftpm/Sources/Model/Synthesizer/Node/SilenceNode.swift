//
//  SilenceNode.swift
//  Sineweaver
//
//  Created on 22.11.24
//

/// A node that emits silence.
struct SilenceNode: SynthesizerNodeProtocol {
    func render(inputs: [SynthesizerNodeInput], output: inout [Double], state: inout Void, context: SynthesizerContext) -> Bool {
        for i in 0..<output.count {
            output[i] = 0
        }
        return false
    }
}
