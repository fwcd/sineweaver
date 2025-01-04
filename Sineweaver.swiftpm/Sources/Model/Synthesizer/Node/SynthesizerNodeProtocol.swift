//
//  SynthesizerNodeProtocol.swift
//  Sineweaver
//
//  Created on 22.11.24
//

import Foundation

/// A node that generates or processes audio.
protocol SynthesizerNodeProtocol: Hashable, Codable, Sendable {
    associatedtype State = Void
    
    func makeState() -> State

    func render(inputs: [[Double]], output: inout [Double], state: inout State, context: SynthesizerContext)
}

extension SynthesizerNodeProtocol where State == Void {
    func makeState() {}
    
    func render(inputs: [[Double]], output: inout [Double], context: SynthesizerContext) {
        var void: Void = ()
        render(inputs: inputs, output: &output, state: &void, context: context)
    }
}
