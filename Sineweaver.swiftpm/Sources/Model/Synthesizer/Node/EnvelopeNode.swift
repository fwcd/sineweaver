//
//  EnvelopeNode.swift
//  Sineweaver
//
//  Created on 05.01.25
//

import Foundation

/// A node that applies an ADSR envelope to a signal.
struct EnvelopeNode: SynthesizerNodeProtocol {
    var attack: Duration = .zero
    var decay: Duration = .zero
    var sustain: Double = 1
    var release: Duration = .zero
    
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
