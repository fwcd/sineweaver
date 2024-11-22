//
//  SynthesizerModel.swift
//  Fourier Synth
//
//  Created on 22.11.24
//

import Foundation

/// A synthesizer modeled as a graph of processing nodes.
struct SynthesizerModel: Hashable, Codable, Sendable {
    var nodes: [UUID: SynthesizerNode] = [:]
    var edges: [UUID: [UUID]] = [:]
    var context: SynthesizerContext = .init()
}
