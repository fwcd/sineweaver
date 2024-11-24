//
//  SynthesizerContext.swift
//  Sineweaver
//
//  Created on 22.11.24
//

/// The state of the synthesizer relevant for rendering individual nodes.
struct SynthesizerContext: Hashable, Codable, Sendable {
    var frame: Int = 0
    var sampleRate: Double = 0
}
