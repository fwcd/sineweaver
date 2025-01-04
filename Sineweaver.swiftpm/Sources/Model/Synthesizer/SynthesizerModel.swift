//
//  SynthesizerModel.swift
//  Sineweaver
//
//  Created on 22.11.24
//

import Foundation

/// A synthesizer modeled as a graph of processing nodes.
struct SynthesizerModel: Hashable, Codable, Sendable {
    var nodes: [UUID: SynthesizerNode] = [:]
    var inputEdges: [UUID: [UUID]] = [:]
    var outputNodeId: UUID? = nil
    
    var edges: [Edge] {
        inputEdges.flatMap { destId, srcIds in
            srcIds.map { Edge(srcId: $0, destId: destId) }
        }
    }
    
    struct Edge: Hashable {
        let srcId: UUID
        let destId: UUID
    }
    
    static func withMixerOutput() -> Self {
        var model = Self()
        model.outputNodeId = model.add(node: .mixer(.init()))
        return model
    }
    
    @discardableResult
    mutating func add(node: SynthesizerNode) -> UUID {
        let nodeId = UUID()
        nodes[nodeId] = node
        inputEdges[nodeId] = []
        return nodeId
    }
    
    mutating func connect(_ inputId: UUID, to outputId: UUID) {
        guard nodes.keys.contains(inputId) else {
            fatalError("Cannot connect invalid input id: \(inputId)")
        }
        guard nodes.keys.contains(outputId) else {
            fatalError("Cannot connect invalid output id: \(outputId)")
        }
        if !inputEdges.keys.contains(outputId) {
            inputEdges[outputId] = []
        }
        inputEdges[outputId]!.append(inputId)
    }
    
    struct Buffers: Sendable {
        var inputs: [UUID: [[Double]]] = [:]
        var output: [Double] = []
        
        var frameCount: Int? = nil
        var outputId: UUID? = nil
    }
    
    struct States: Sendable {
        var inputs: [UUID: any Sendable] = [:]
        var output: (any Sendable)? = nil
    }
    
    func update(buffers: inout Buffers, frameCount: Int) {
        let frameCountMatches = frameCount == buffers.frameCount
        
        let oldNodeIds = Set(buffers.inputs.keys)
        let newNodeIds = Set(nodes.keys)

        let removedNodeIds = frameCountMatches ? oldNodeIds.subtracting(newNodeIds) : oldNodeIds
        let addedNodeIds = frameCountMatches ? newNodeIds.subtracting(oldNodeIds) : newNodeIds
        
        for id in removedNodeIds {
            buffers.inputs[id] = nil
        }
        
        for id in addedNodeIds {
            buffers.inputs[id] = (inputEdges[id] ?? []).map { _ -> [Double] in
                [Double](repeating: 0, count: frameCount)
            }
        }
        
        if !frameCountMatches || outputNodeId != buffers.outputId {
            buffers.output = [Double](repeating: 0, count: frameCount)
        }
        
        buffers.frameCount = frameCount
        buffers.outputId = outputNodeId
        
        assert(buffers.inputs.count == nodes.count)
        assert(buffers.output.count == frameCount)
    }
    
    func update(states: inout States) {
        let oldNodeIds = Set(states.inputs.keys)
        let newNodeIds = Set(nodes.keys)
        
        let removedNodeIds = oldNodeIds.subtracting(newNodeIds)
        let addedNodeIds = newNodeIds.subtracting(oldNodeIds)
        
        for id in removedNodeIds {
            states.inputs[id] = nil
        }
        
        for id in addedNodeIds {
            states.inputs[id] = nodes[id]!.makeState()
        }
        
        if let outputNodeId, let outputNode = nodes[outputNodeId] {
            states.output = outputNode.makeState()
        }
    }
    
    mutating func render(using buffers: inout Buffers, states: inout States, context: SynthesizerContext) {
        if let outputNodeId {
            render(nodeId: outputNodeId, to: nil, using: &buffers, states: &states, context: context)
        }
    }
    
    private mutating func render(nodeId: UUID, to output: (id: UUID, i: Int)?, using buffers: inout Buffers, states: inout States, context: SynthesizerContext) {
        let inputIds = inputEdges[nodeId] ?? []
        
        for (i, inputId) in inputIds.enumerated() {
            // TODO: Detect cycles and prevent duplicate rendering in non-tree DAGs by tracking visits etc.
            render(
                nodeId: inputId,
                to: (id: nodeId, i: i),
                using: &buffers,
                states: &states,
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
                state: &states.inputs[nodeId]!,
                context: context
            )
        } else {
            node.render(
                inputs: inputBuffers,
                output: &buffers.output,
                state: &states.output!,
                context: context
            )
        }
        
        nodes[nodeId] = node
    }
}
