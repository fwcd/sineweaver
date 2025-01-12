//
//  InverterNode.swift
//  Sineweaver
//
//  Created on 12.01.25
//

/// A node that inverts a normalized (e.g. LFO) signal.
struct InverterNode: SynthesizerNodeProtocol {
    func render(inputs: [SynthesizerNodeInput], output: inout [Double], state: inout (), context: SynthesizerContext) -> Bool {
        guard let input = inputs.first else { return false }
        
        for i in 0..<output.count {
            output[i] = 1 - input.buffer[i]
        }
        
        return input.isActive
    }
}
