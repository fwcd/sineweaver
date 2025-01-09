//
//  SynthesizerModel.swift
//  Sineweaver
//
//  Created on 22.11.24
//

import Foundation
import OSLog

private let log = Logger(subsystem: "Sineweaver", category: "SynthesizerModel")

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
    
    var isActive: Bool {
        nodes.values.contains(where: \.isActive)
    }
    
    struct ToposortedNode: Identifiable {
        let id: UUID
        let node: SynthesizerNode
        let depth: Int
    }
    
    var toposortedNodes: [ToposortedNode] {
        var sorted: [ToposortedNode] = []
        var visited: Set<UUID> = []
        
        func dfs(from id: UUID, depth: Int = 0) {
            guard !visited.contains(id) else { return }
            visited.insert(id)
            
            for input in (inputEdges[id] ?? []) {
                dfs(from: input, depth: depth + 1)
            }
            
            if let node = nodes[id] {
                sorted.append(.init(
                    id: id,
                    node: node,
                    depth: depth
                ))
            }
        }
        
        for id in nodes.keys.sorted(by: ascendingComparator { $0 == outputNodeId ? 0 : 1 }) {
            if !visited.contains(id) {
                dfs(from: id)
            }
        }
        
        return sorted
    }
    
    struct Edge: Hashable {
        let srcId: UUID
        let destId: UUID
    }
    
    static func withMixerOutput() -> Self {
        var model = Self()
        model.outputNodeId = model.addNode(.mixer(.init()))
        return model
    }
    
    @discardableResult
    mutating func addNode(id: UUID = UUID(), _ node: SynthesizerNode) -> UUID {
        nodes[id] = node
        inputEdges[id] = []
        return id
    }
    
    mutating func removeNode(id: UUID) {
        if outputNodeId == id {
            outputNodeId = inputEdges[id]?.first
        }
        nodes[id] = nil
        inputEdges[id] = []
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
        
        var outputId: UUID? = nil
    }
    
    func update(buffers: inout Buffers, frameCount: Int) {
        let frameCountMatches = frameCount == buffers.frameCount
        
        buffers.inputs = [:]
        
        for id in nodes.keys {
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
        
        if outputNodeId != states.outputId {
            states.output = outputNodeId.flatMap { nodes[$0] }?.makeState()
            states.outputId = outputNodeId
        }
    }
    
    mutating func render(using buffers: inout Buffers, states: inout States, context: SynthesizerContext) {
        if let outputNodeId {
            render(nodeId: outputNodeId, to: nil, using: &buffers, states: &states, context: context)
        }
    }
    
    @discardableResult
    private mutating func render(nodeId: UUID, to output: (id: UUID, i: Int)?, using buffers: inout Buffers, states: inout States, context: SynthesizerContext) -> Bool {
        let inputIds = inputEdges[nodeId] ?? []
        var inputsActive = Array(repeating: false, count: inputIds.count)
        
        for (i, inputId) in inputIds.enumerated() {
            // TODO: Detect cycles and prevent duplicate rendering in non-tree DAGs by tracking visits etc.
            inputsActive[i] = render(
                nodeId: inputId,
                to: (id: nodeId, i: i),
                using: &buffers,
                states: &states,
                context: context
            )
        }
        
        guard let node = nodes[nodeId] else {
            log.critical("Unknown node id: \(nodeId)")
            return false
        }
        
        guard let inputBuffers = buffers.inputs[nodeId] else {
            log.critical("No input buffers for node id: \(nodeId)")
            return false
        }
        
        let inputs = zip(inputsActive, inputBuffers).map { SynthesizerNodeInput(isActive: $0.0, buffer: $0.1) }
        
        let result = if let output {
            node.render(
                inputs: inputs,
                output: &buffers.inputs[output.id]![output.i],
                state: &states.inputs[nodeId]!,
                context: context
            )
        } else {
            node.render(
                inputs: inputs,
                output: &buffers.output,
                state: &states.output!,
                context: context
            )
        }
        
        nodes[nodeId] = node
        return result
    }
}
