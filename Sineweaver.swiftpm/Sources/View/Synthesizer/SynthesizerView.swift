//
//  SynthesizerView.swift
//  Sineweaver
//
//  Created on 27.12.24
//

import SwiftUI

struct SynthesizerView<Level>: View where Level: View {
    typealias ToposortedNode = SynthesizerModel.ToposortedNode
    
    @Binding var model: SynthesizerModel
    var startDate: Date = Date()
    var hiddenNodeIds: Set<UUID> = []
    var allowsEditing = false
    var showDebugFrames = false
    var nodeSpacing: CGFloat = 30
    @ViewBuilder var level: () -> Level
    
    @State private var hovered: Set<UUID> = []
    @State private var frames: [UUID: [Int: CGRect]] = [:]
    @State private var levelFrame: CGRect? = nil
    @State private var insertionPopover: InsertionPoint? = nil
    @State private var addFirstNodePopoverShown = false
    @State private var nodeRemovalWarning: NodeRemovalWarning? = nil
    @State private var nodeInsertionWarning: NodeInsertionWarning? = nil
    @State private var connectError: SynthesizerModel.ConnectError? = nil
    @State private var activeDrag: Drag? = nil
    
    @Namespace private var animation
    
    private var coordinateSpace: NamedCoordinateSpace {
        .named("SynthesizerView")
    }

    private typealias InsertionPoint = SynthesizerModel.InsertionPoint
    
    private struct NodeRemovalWarning: Hashable {
        let id: UUID
        let text: String
    }
    
    private struct NodeInsertionWarning: Hashable {
        let insertionPoint: InsertionPoint?
        let type: SynthesizerNodeType
        let preChainableTypes: [SynthesizerNodeType]
        let chainableTypes: [SynthesizerNodeType]
        let text: String
    }
    
    private struct Drag: Hashable {
        var startId: UUID
        var startEdge: Edge
        var currentPos: CGPoint
        var hoveredId: UUID? = nil
        var hoversOutput: Bool = false
    }

    var body: some View {
        ZStack {
            Group {
                if showDebugFrames {
                    debugFrames
                }
                edges
            }
            .allowsHitTesting(false)
            
            nodes
            
            overlays
                .allowsHitTesting(false)
        }
        .coordinateSpace(coordinateSpace)
        .alert(nodeInsertionWarning?.text ?? "Add node?", isPresented: $nodeInsertionWarning.notNil) {
            Button("Cancel", role: .cancel) {
                nodeInsertionWarning = nil
            }
            if let nodeInsertionWarning {
                if nodeInsertionWarning.preChainableTypes.isEmpty {
                    ForEach(nodeInsertionWarning.chainableTypes, id: \.self) { chainableType in
                        Button("Add \(chainableType.name)") {
                            addNode(
                                type: nodeInsertionWarning.type,
                                chainedType: chainableType,
                                at: nodeInsertionWarning.insertionPoint
                            )
                            self.nodeInsertionWarning = nil
                        }
                    }
                } else {
                    ForEach(nodeInsertionWarning.preChainableTypes, id: \.self) { preChainableType in
                        ForEach(nodeInsertionWarning.chainableTypes, id: \.self) { chainableType in
                            Button("Add \(preChainableType.name) and \(chainableType.name)") {
                                addNode(
                                    type: nodeInsertionWarning.type,
                                    preChainedType: preChainableType,
                                    chainedType: chainableType,
                                    at: nodeInsertionWarning.insertionPoint
                                )
                                self.nodeInsertionWarning = nil
                            }
                        }
                    }
                }
                Button("Just Add \(nodeInsertionWarning.type.name)", role: .destructive) {
                    addNode(
                        type: nodeInsertionWarning.type,
                        at: nodeInsertionWarning.insertionPoint
                    )
                    self.nodeInsertionWarning = nil
                }
            }
        }
        .alert(nodeRemovalWarning?.text ?? "Remove node?", isPresented: $nodeRemovalWarning.notNil) {
            Button("Cancel", role: .cancel) {
                nodeRemovalWarning = nil
            }
            Button("Remove Node", role: .destructive) {
                if let nodeRemovalWarning {
                    model.removeNode(id: nodeRemovalWarning.id)
                }
                nodeRemovalWarning = nil
            }
        }
        .alert(connectError?.description ?? "Could not connect nodes", isPresented: $connectError.notNil) {
            Button("OK") {
                connectError = nil
            }
        }
    }
    
    @ViewBuilder
    private var debugFrames: some View {
        ForEach(Array(frames), id: \.key) { (_, idFrames) in
            ForEach(Array(idFrames), id: \.key) { (_, frame) in
                Rectangle()
                    .fill(.red.opacity(0.3))
                    .frame(width: frame.size.width, height: frame.size.height)
                    .position(frame.centerPoint())
            }
        }
    }
    
    @ViewBuilder
    private var edges: some View {
        let lineWidth: CGFloat = 2
        let lineColor = Color.gray
        
        ForEach(Array(model.inputEdges), id: \.key) { (id, inputIds) in
            ForEach(inputIds, id: \.self) { inputId in
                Path { path in
                    for (_, frame) in frames[id] ?? [:] {
                        for (_, inputFrame) in frames[inputId] ?? [:] {
                            path.move(to: inputFrame.centerPoint(of: .trailing))
                            path.addLine(to: frame.centerPoint(of: .leading))
                        }
                    }
                }
                .stroke(lineColor, lineWidth: lineWidth)
            }
        }
        
        if let outputNodeId = model.outputNodeId, let levelFrame {
            Path { path in
                for (_, outputFrame) in frames[outputNodeId] ?? [:] {
                    path.move(to: outputFrame.centerPoint(of: .trailing))
                    path.addLine(to: levelFrame.centerPoint(of: .leading))
                }
            }
            .stroke(lineColor, lineWidth: lineWidth)
        }
        
        if let activeDrag, let frame = frames[activeDrag.startId]?.values.first {
            Path { path in
                path.move(to: frame.centerPoint(of: activeDrag.startEdge))
                path.addLine(to: activeDrag.currentPos)
            }
            .stroke(lineColor, lineWidth: lineWidth)
        }
    }
    
    @ViewBuilder
    private var nodes: some View {
        HStack(spacing: nodeSpacing) {
            if model.nodes.isEmpty && allowsEditing {
                Button {
                    addFirstNodePopoverShown = true
                } label: {
                    Label("Add Node", systemImage: "plus")
                }
                .buttonStyle(.bordered)
                .popover(isPresented: $addFirstNodePopoverShown) {
                    nodeInsertionPopover()
                }
            }
        
            let tnodes: [ToposortedNode] = model.toposortedNodes
                .filter { !hiddenNodeIds.contains($0.id) }
            let groups = Dictionary(grouping: tnodes, by: \.depth)
                .sorted { $0.key > $1.key }
                .map { (id: $0.key, group: $0.value) }
            
            ForEach(groups, id: \.id) { (depth, group) in
                VStack(alignment: .trailing, spacing: nodeSpacing) {
                    ForEach(group) { (tnode: ToposortedNode) in
                        let id = tnode.id
                        let showsHUD = (allowsEditing && hovered.contains(id)) || insertionPopover?.id == id
                        SynthesizerNodeView(
                            node: $model.nodes[id].unwrapped(or: SynthesizerNode()),
                            inputNodes: model.inputEdges[id]?.compactMap { model.nodes[$0] } ?? [],
                            startDate: startDate,
                            // TODO: Propagate the 'true' activeness instead of using this heuristic
                            isActive: model.hasActiveAncestor(id: id),
                            allowsEditing: allowsEditing
                        ) {
                            if showsHUD {
                                toolbar(for: id, in: coordinateSpace)
                                    .padding(.bottom, 5)
                            }
                        } handle: { edge in
                            if showsHUD {
                                handle(for: id, edge: edge)
                            }
                        }
                        .background(FrameReader(in: coordinateSpace) { frame in
                            var idFrames = frames[id] ?? [:]
                            idFrames[depth] = frame
                            frames[id] = idFrames
                        })
                        .fixedSize()
                        .onHover { over in
                            if over {
                                hovered.insert(id)
                            } else {
                                hovered.remove(id)
                            }
                        }
                        .matchedGeometryEffect(id: id, in: animation)
                    }
                }
            }
            level()
                .background(FrameReader(in: coordinateSpace) { frame in
                    levelFrame = frame
                })
        }
        .animation(.default, value: model.inputEdges)
        .animation(.default, value: Set(model.nodes.keys))
    }
    
    @ViewBuilder
    private var overlays: some View {
        let frame = activeDrag?.hoveredId.flatMap { frames[$0]?.values.first }
            ?? ((activeDrag?.hoversOutput ?? false) ? levelFrame : nil)
        if let frame {
            RoundedRectangle(cornerRadius: 10)
                .fill(.gray.opacity(0.3))
                .frame(width: frame.size.width, height: frame.size.height)
                .position(frame.centerPoint())
        }
    }
    
    @ViewBuilder
    private func toolbar(for id: UUID, in coordinateSpace: some CoordinateSpaceProtocol) -> some View {
        Button {
            guard let node = model.nodes[id] else { return }
            if node.type.isGate,
               id == model.outputNodeId,
               (model.inputEdges[id]?.count ?? 0) > 0,
               !(model.inputEdges[id]?.contains(where: { model.nodes[$0]?.type.isGate ?? false }) ?? false) {
                nodeRemovalWarning = .init(
                    id: id,
                    text: "Removing this node will pass sound straight from its inputs to the output, regardless of whether e.g. an oscillator key is pressed or not. Thus removing the node may result in a continuous tone playing from your speaker. Are you sure you wish to remove this node?"
                )
            } else {
                model.removeNode(id: id)
            }
        } label: {
            Image(systemName: "multiply")
        }
        .buttonStyle(.plain)
    }
    
    @ViewBuilder
    private func handle(for id: UUID, edge: Edge) -> some View {
        let insertionPoint = InsertionPoint(id: id, edge: edge)
        Button {
            insertionPopover = insertionPoint
        } label: {
            Image(systemName: "plus.circle")
        }
        .simultaneousGesture(
            DragGesture(coordinateSpace: coordinateSpace)
                .onChanged { value in
                    let pos = value.location
                    var activeDrag = activeDrag ?? .init(startId: id, startEdge: edge, currentPos: pos)
                    
                    activeDrag.currentPos = pos
                    activeDrag.hoveredId = frames
                        .filter { $0.key != id && $0.value.values.contains { $0.contains(pos) } }
                        .map { $0.key }
                        .first
                    activeDrag.hoversOutput = levelFrame?.contains(pos) ?? false

                    self.activeDrag = activeDrag
                }
                .onEnded { _ in
                    if let activeDrag {
                        if activeDrag.hoversOutput {
                            model.outputNodeId = activeDrag.startId
                        } else if let hoveredId = activeDrag.hoveredId {
                            let startId = activeDrag.startId
                            do {
                                if model.hasConnection(from: startId, to: hoveredId) {
                                    model.disconnect(startId, from: hoveredId)
                                } else {
                                    try model.connect(startId, to: hoveredId)
                                }
                            } catch let error as SynthesizerModel.ConnectError {
                                connectError = error
                            } catch {
                                // Unreachable
                            }
                        }
                    }
                    activeDrag = nil
                }
        )
        .buttonStyle(.plain)
        .popover(isPresented: Binding {
            insertionPopover == insertionPoint
        } set: {
            insertionPopover = $0 ? insertionPoint : nil
        }, arrowEdge: edge.opposite) {
            nodeInsertionPopover(insertionPoint: insertionPoint)
        }
    }
    
    @ViewBuilder
    private func nodeInsertionPopover(insertionPoint: InsertionPoint? = nil) -> some View {
        let localOutputIds: Set<UUID> = if let insertionPoint {
            if insertionPoint.edge == .leading {
                [insertionPoint.id]
            } else {
                model.outputEdges(id: insertionPoint.id)
            }
        } else {
            []
        }
        
        VStack {
            ForEach(SynthesizerNodeType.allCases, id: \.self) { type in
                Button(type.name) {
                    if type.isGenerator && localOutputIds.isEmpty {
                        nodeInsertionWarning = .init(
                            insertionPoint: insertionPoint,
                            type: type,
                            preChainableTypes: type == .oscillator ? [] : [.controller],
                            chainableTypes: [
                                .envelope,
                                .activeGate,
                            ],
                            text: "Connecting a generating node (e.g. an oscillator) to the output will immediately produce a continuous sound, regardless of whether a key is pressed. Adding an envelope or an active gate will only let sound through if the node is actively played. Do you want to add one of these too?"
                        )
                    } else if type.isDigitalControl, localOutputIds.isEmpty || localOutputIds.contains(where: { ![.oscillator, .noise].contains(model.nodes[$0]?.type) }) {
                        nodeInsertionWarning = .init(
                            insertionPoint: insertionPoint,
                            type: type,
                            preChainableTypes: [],
                            chainableTypes: [
                                .oscillator
                            ],
                            text: "Connecting a control node to an audio node may produce loud pops/clicks, since the (digital) control signal will be passed onto an audio path. This may be unexpected. Do you want to add an intermediate oscillator?"
                        )
                    } else {
                        addNode(type: type, at: insertionPoint)
                    }
                }
            }
        }
        .padding()
    }
    
    @discardableResult
    private func addNode(
        type: SynthesizerNodeType,
        preChainedType: SynthesizerNodeType? = nil,
        chainedType: SynthesizerNodeType? = nil,
        at insertionPoint: InsertionPoint? = nil
    ) -> UUID {
        var id = insertNode(type: type, at: insertionPoint)
        
        if let preChainedType {
            insertNode(type: preChainedType, at: .init(id: id, edge: .leading))
        }
        
        if let chainedType {
            let chainedInsertionPoint: InsertionPoint = switch insertionPoint?.edge {
            case .leading: insertionPoint!
            default: .init(id: id, edge: .trailing)
            }
            id = insertNode(type: chainedType, at: chainedInsertionPoint)
        }
        
        if model.outputEdges(id: id).isEmpty {
            model.outputNodeId = id
        }
        
        return id
    }
    
    @discardableResult
    private func insertNode(type: SynthesizerNodeType, at insertionPoint: InsertionPoint? = nil) -> UUID {
        let node = SynthesizerNode(type: type)
        return if let insertionPoint {
            model.insertNode(at: insertionPoint, node)
        } else {
            model.addNode(node)
        }
    }
}

#Preview(traits: .landscapeLeft) {
    @Previewable @State var model = SynthesizerModel()
    
    SynthesizerView(model: $model, allowsEditing: true) {}
        .onAppear {
            model = SynthesizerChapter.fullyConfiguredSynthesizer
        }
}
