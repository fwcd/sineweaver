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

    @discardableResult
    func render(inputs: [SynthesizerNodeInput], output: inout [Double], state: inout State, context: SynthesizerContext) -> Bool
}

extension SynthesizerNodeProtocol where State == Void {
    func makeState() {}
    
    @discardableResult
    func render(inputs: [SynthesizerNodeInput], output: inout [Double], context: SynthesizerContext) -> Bool {
        var void: Void = ()
        return render(inputs: inputs, output: &output, state: &void, context: context)
    }
}
