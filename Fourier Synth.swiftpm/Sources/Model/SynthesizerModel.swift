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
        var inputs: [UUID: [[Double]]]
        var output: [Double]
    }
    
    func makeBuffers(frameCount: Int) -> Buffers {
        Buffers(
            inputs: Dictionary(uniqueKeysWithValues: nodes.map { (key, _) in
                (key, (inputEdges[key] ?? []).map { _ -> [Double] in
                    [Double](repeating: 0, count: frameCount)
                })
            }),
            output: [Double](repeating: 0, count: frameCount)
        )
    }
    
    func render(using buffers: inout Buffers) {
        guard let outputNodeId else {
            fatalError("Cannot render without an output node id")
        }
        
        render(nodeId: outputNodeId, to: nil, using: &buffers, context: context)
    }
    
    private func render(nodeId: UUID, to output: (id: UUID, i: Int)?, using buffers: inout Buffers, context: SynthesizerContext) {
        let inputIds = inputEdges[nodeId] ?? []
        
        for (i, inputId) in inputIds.enumerated() {
            // TODO: Detect cycles and prevent duplicate rendering in non-tree DAGs by tracking visits etc.
            render(
                nodeId: inputId,
                to: (id: nodeId, i: i),
                using: &buffers,
                context: context
            )
        }
        
        guard let node = nodes[nodeId] else {
            fatalError("Unknown node id: \(nodeId)")
        }
        
        guard let inputBuffers = buffers.inputs[nodeId] else {
            fatalError("No input buffers for node id: \(nodeId)")
        }
        
        if let output {
            node.render(
                inputs: inputBuffers,
                output: &buffers.inputs[output.id]![output.i],
                context: context
            )
        } else {
            node.render(
                inputs: inputBuffers,
                output: &buffers.output,
                context: context
            )
        }
    }
}
