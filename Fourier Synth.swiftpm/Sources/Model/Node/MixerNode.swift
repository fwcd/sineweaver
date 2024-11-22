//
//  MixerNode.swift
//  Fourier Synth
//
//  Created on 22.11.24
//

/// A simple sum of its inputs.
struct MixerNode: SynthesizerNodeProtocol {
    func render(inputs: [[Double]], output: inout [Double], context: SynthesizerContext) {
        for i in 0..<output.count {
            output[i] = 0
            for input in inputs {
                output[i] += input[i]
            }
        }
    }
}
