//
//  SynthesizerNodeProtocol.swift
//  Sineweaver
//
//  Created on 22.11.24
//

import Foundation

/// A node that generates or processes audio.
protocol SynthesizerNodeProtocol: Hashable, Codable, Sendable {
    func render(inputs: [[Double]], output: inout [Double], context: SynthesizerContext)
}
