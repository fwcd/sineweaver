//
//  MixerNode.swift
//  Sineweaver
//
//  Created on 22.11.24
//

/// A simple sum of its inputs.
struct MixerNode: SynthesizerNodeProtocol {
    func render(inputs: [SynthesizerNodeInput], output: inout [Double], state: inout Void, context: SynthesizerContext) -> Bool {
        for i in 0..<output.count {
            output[i] = 0
            for input in inputs {
                output[i] += input.buffer[i]
            }
        }
        return true
    }
}
