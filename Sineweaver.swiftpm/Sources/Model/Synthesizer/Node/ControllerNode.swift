//
//  ControllerNode.swift
//  Sineweaver
//
//  Created on 11.01.25
//

/// A node that generates a control signal consisting of a frequency.
struct ControllerNode: SynthesizerNodeProtocol {
    var frequency: Double = 440
    var pianoBaseOctave: Int = 3
    var isActive = false

    func render(inputs: [SynthesizerNodeInput], output: inout [Double], state: inout State, context: SynthesizerContext) -> Bool {
        for i in 0..<output.count {
            output[i] = frequency
        }
        return isActive
    }
}
