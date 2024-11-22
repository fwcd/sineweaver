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
    var inputEdges: [UUID: [UUID]] = [:]
    var outputNodeId: UUID? = nil
    var context: SynthesizerContext = .init()
    
    struct Buffers: Sendable {
        var buffers: [UUID: [[Double]]]
    }
    
    func makeBuffers(frameCount: Int) -> Buffers {
        Buffers(
            buffers: Dictionary(uniqueKeysWithValues: nodes.map { (key, _) in
                (key, (inputEdges[key] ?? []).map { _ -> [Double] in
                    [Double](repeating: 0, count: frameCount)
                })
            })
        )
    }
    
    // TODO: Detect cycles and prevent duplicate rendering in non-tree DAGs by tracking visits etc.
    func render(nodeId: UUID, using buffers: inout Buffers) {
        let inputIds = inputEdges[nodeId] ?? []
        // TODO
    }
}
