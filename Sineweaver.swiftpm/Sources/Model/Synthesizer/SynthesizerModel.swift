//
//  SynthesizerModel.swift
//  Sineweaver
//
//  Created on 22.11.24
//

import Foundation
import OSLog
import enum SwiftUI.Edge

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
    
    struct InsertionPoint: Hashable {
        let id: UUID
        let edge: SwiftUI.Edge
    }
    
    @discardableResult
    mutating func insertNode(at insertionPoint: InsertionPoint, id: UUID = UUID(), _ node: SynthesizerNode) -> UUID {
        nodes[id] = node
        inputEdges[id] = []
        
        switch insertionPoint.edge {
        case .top:
            inputEdges = inputEdges.mapValues { $0.flatMap { $0 == insertionPoint.id ? [id, $0] : [$0] } }
        case .bottom:
            inputEdges = inputEdges.mapValues { $0.flatMap { $0 == insertionPoint.id ? [$0, id] : [$0] } }
        case .leading:
            inputEdges[id] = inputEdges[insertionPoint.id]
            inputEdges[insertionPoint.id] = [id]
        case .trailing:
            inputEdges = inputEdges.mapValues { $0.map { $0 == insertionPoint.id ? id : $0 } }
            inputEdges[id] = [insertionPoint.id]
            
            if insertionPoint.id == outputNodeId {
                outputNodeId = id
            }
        }
        
        return id
    }
    
    mutating func removeNode(id: UUID) {
        let inputIds = inputEdges[id] ?? []
        
        if outputNodeId == id {
            outputNodeId = inputIds.first
        }
        
        for outId in outputEdges(id: id) {
            inputEdges[outId] = inputEdges[outId]?.flatMap { $0 == id ? inputIds : [$0] }
        }
        
        nodes[id] = nil
        inputEdges[id] = []
    }
    
    func outputEdges(id: UUID) -> Set<UUID> {
        Set(inputEdges.filter { $0.value.contains(id) }.map(\.key))
    }
    
    enum ConnectError: Error, CustomStringConvertible {
        case sameInputAsOutput
        case invalidInput(UUID)
        case invalidOutput(UUID)
        case cycle
        case alreadyConnected
        
        var description: String {
            switch self {
            case .sameInputAsOutput: "Input and output are the same!"
            case .invalidInput(let id): "Input node \(id) does not exist!"
            case .invalidOutput(let id): "Output node \(id) does not exist!"
            case .cycle: "Connection would create a cycle!"
            case .alreadyConnected: "Connection already exists!"
            }
        }
    }
    
    mutating func connect(_ inputId: UUID, to outputId: UUID) throws(ConnectError) {
        guard inputId != outputId else {
            throw ConnectError.sameInputAsOutput
        }
        guard nodes.keys.contains(inputId) else {
            throw ConnectError.invalidInput(inputId)
        }
        guard nodes.keys.contains(outputId) else {
            throw ConnectError.invalidOutput(outputId)
        }
        guard !hasPath(from: outputId, to: inputId) else {
            throw ConnectError.cycle
        }
        var inputs = inputEdges[outputId] ?? []
        guard !inputs.contains(inputId) else {
            throw ConnectError.alreadyConnected
        }
        inputs.append(inputId)
        inputEdges[outputId] = inputs
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
    
    func hasPath(from startId: UUID, to endId: UUID) -> Bool {
        // Perform a DFS to look for a path
        
        var visited: Set<UUID> = []
        var stack: [UUID] = [endId]
        
        while let nextId = stack.popLast() {
            guard !visited.contains(nextId) else { continue }
            visited.insert(nextId)
            
            for parentId in inputEdges[nextId] ?? [] {
                if parentId == startId {
                    return true
                }
                stack.append(parentId)
            }
        }
        
        return false
    }
    
    func hasActiveAncestor(id: UUID) -> Bool {
        guard let node = nodes[id] else { return false }
        if node.isActive {
            return true
        }
        
        guard let inputs = inputEdges[id] else { return false }
        return inputs.contains { hasActiveAncestor(id: $0) }
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
