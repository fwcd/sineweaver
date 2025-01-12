//
//  GainNode.swift
//  Sineweaver
//
//  Created on 12.01.25
//

/// A node that amplifies or attenuates a signal.
struct GainNode: SynthesizerNodeProtocol {
    var gain: Double = 1
    
    func render(inputs: [SynthesizerNodeInput], output: inout [Double], state: inout (), context: SynthesizerContext) -> Bool {
        guard let input = inputs.first else { return false }
        
        for i in 0..<output.count {
            output[i] = gain * input.buffer[i]
        }
        
        return input.isActive
    }
}
