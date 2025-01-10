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
    var debugFrames = false
    @ViewBuilder var level: () -> Level
    
    @State private var hovered: Set<UUID> = []
    @State private var frames: [UUID: CGRect] = [:]
    @State private var levelFrame: CGRect? = nil
    @State private var dockNewNodePopover: (id: UUID, edge: Edge)? = nil
    @State private var addNewNodePopoverShown = false
    @State private var nodeRemovalWarning: NodeRemovalWarning? = nil

    private struct NodeRemovalWarning {
        let id: UUID
        let text: String?
    }

    var body: some View {
        let coordinateSpace: NamedCoordinateSpace = .named("SynthesizerView")
        let nodeSpacing: CGFloat = 30
        
        ZStack {
            Group {
                ForEach(Array(frames), id: \.key) { (id, frame) in
                    Rectangle()
                        .fill(debugFrames ? .red.opacity(0.3) : .clear)
                        .frame(width: frame.size.width, height: frame.size.height)
                        .position(x: frame.midX, y: frame.midY)
                }
                
                ForEach(Array(model.inputEdges), id: \.key) { (id, inputIds) in
                    ForEach(inputIds, id: \.self) { inputId in
                        if let frame = frames[id],
                           let inputFrame = frames[inputId] {
                            Path { path in
                                path.move(to: CGPoint(x: inputFrame.maxX, y: inputFrame.midY))
                                path.addLine(to: CGPoint(x: frame.minX, y: frame.midY))
                            }
                            .stroke(.gray, lineWidth: 2)
                        }
                    }
                }
                
                if let outputNodeId = model.outputNodeId,
                   let outputFrame = frames[outputNodeId],
                   let levelFrame {
                    Path { path in
                        path.move(to: CGPoint(x: outputFrame.maxX, y: outputFrame.midY))
                        path.addLine(to: CGPoint(x: levelFrame.minX, y: levelFrame.midY))
                    }
                    .stroke(.gray, lineWidth: 2)
                }
            }
            .allowsHitTesting(false)
            
            HStack(spacing: nodeSpacing) {
                if model.nodes.isEmpty {
                    Button {
                        addNewNodePopoverShown = true
                    } label: {
                        Label("Add Node", systemImage: "plus")
                    }
                    .buttonStyle(.bordered)
                    .popover(isPresented: $addNewNodePopoverShown) {
                        newNodePopover()
                    }
                }
            
                let tnodes: [ToposortedNode] = model.toposortedNodes
                    .filter { !hiddenNodeIds.contains($0.id) }
                let groups = Dictionary(grouping: tnodes, by: \.depth)
                    .sorted { $0.key > $1.key }
                    .map { (id: $0.value.first?.id, group: $0.value) }
                
                ForEach(groups, id: \.id) { (_, group) in
                    VStack(alignment: .trailing, spacing: nodeSpacing) {
                        ForEach(group) { (tnode: ToposortedNode) in
                            let id = tnode.id
                            let showsHUD = (allowsEditing && hovered.contains(id)) || dockNewNodePopover?.id == id
                            SynthesizerNodeView(
                                node: $model.nodes[id].unwrapped,
                                startDate: startDate,
                                isActive: model.isActive
                            ) {
                                if showsHUD {
                                    toolbar(for: id, in: coordinateSpace)
                                        .padding(.bottom, 5)
                                }
                            } dock: { edge in
                                if showsHUD {
                                    dock(for: id, edge: edge)
                                }
                            }
                            .background(FrameReader(in: coordinateSpace) { frame in
                                frames[id] = frame
                            })
                            .fixedSize()
                            .onHover { over in
                                if over {
                                    hovered.insert(id)
                                } else {
                                    hovered.remove(id)
                                }
                            }
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
        .coordinateSpace(coordinateSpace)
        .alert(nodeRemovalWarning?.text ?? "Remove node?", isPresented: Binding {
            nodeRemovalWarning != nil
        } set: {
            nodeRemovalWarning = $0 ? nodeRemovalWarning : nil
        }) {
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
    }
    
    @ViewBuilder
    private func toolbar(for id: UUID, in coordinateSpace: some CoordinateSpaceProtocol) -> some View {
        Button {
            guard let node = model.nodes[id] else { return }
            if (node.type == .envelope || node.type == .activeGate) && id == model.outputNodeId {
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
    private func dock(for id: UUID, edge: Edge) -> some View {
        let key = (id: id, edge: edge)
        Button {
            dockNewNodePopover = key
        } label: {
            Image(systemName: "plus.circle")
        }
        .buttonStyle(.plain)
        .popover(isPresented: Binding {
            dockNewNodePopover?.id == id && dockNewNodePopover?.edge == edge
        } set: {
            dockNewNodePopover = $0 ? key : nil
        }, arrowEdge: edge.opposite) {
            newNodePopover(id: id, edge: edge)
        }
    }
    
    @ViewBuilder
    private func newNodePopover(id: UUID? = nil, edge: Edge? = nil) -> some View {
        VStack {
            ForEach(SynthesizerNodeType.allCases, id: \.self) { type in
                Button(type.name) {
                    if let id, let edge {
                        model.insertNode(around: id, at: edge, .init(type: type))
                    } else {
                        let id = model.addNode(.init(type: type))
                        if model.outputNodeId == nil {
                            model.outputNodeId = id
                        }
                    }
                }
            }
        }
        .padding()
    }
}

#Preview(traits: .landscapeLeft) {
    @Previewable @State var model = SynthesizerModel()
    
    SynthesizerView(model: $model, allowsEditing: true) {}
        .onAppear {
            model = SynthesizerChapter.fullyConfiguredSynthesizer
        }
}
