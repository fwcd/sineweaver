//
//  ActiveGateNode.swift
//  Sineweaver
//
//  Created on 05.01.25
//

/// A node that emits the input if active.
struct ActiveGateNode: SynthesizerNodeProtocol {
    func render(inputs: [SynthesizerNodeInput], output: inout [Double], state: inout (), context: SynthesizerContext) -> Bool {
        guard let input = inputs.first else { return false }
        
        for i in 0..<output.count {
            output[i] = input.isActive ? input.buffer[i] : 0
        }
        
        return input.isActive
    }
}
