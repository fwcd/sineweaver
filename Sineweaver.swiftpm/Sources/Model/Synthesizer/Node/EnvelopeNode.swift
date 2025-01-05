//
//  EnvelopeNode.swift
//  Sineweaver
//
//  Created on 05.01.25
//

import Foundation

/// A node that applies an ADSR envelope to a signal.
struct EnvelopeNode: SynthesizerNodeProtocol {
    var attackMs: Double = 0
    var decayMs: Double = 0
    var sustain: Double = 1
    var releaseMs: Double = 0
    
    struct State {
        var duration: Duration = .zero
    }
    
    func makeState() -> State {
        State()
    }
    
    func render(inputs: [[Double]], output: inout [Double], state: inout State, context: SynthesizerContext) {
        // TODO
    }
}
