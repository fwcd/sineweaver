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
    @State private var newNodePopover: (id: UUID, edge: Edge)? = nil
    @State private var frames: [UUID: CGRect] = [:]

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
            }
            .allowsHitTesting(false)
            
            HStack(spacing: nodeSpacing) {
                let tnodes: [ToposortedNode] = model.toposortedNodes
                    .filter { !hiddenNodeIds.contains($0.id) }
                let groups = Dictionary(grouping: tnodes, by: \.depth)
                    .sorted { $0.key > $1.key }
                    .map { (id: $0.value.first?.id, group: $0.value) }
                
                ForEach(groups, id: \.id) { (_, group) in
                    VStack(alignment: .trailing, spacing: nodeSpacing) {
                        ForEach(group) { (tnode: ToposortedNode) in
                            let id = tnode.id
                            let showsHUD = (allowsEditing && hovered.contains(id)) || newNodePopover?.id == id
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
            }
            .animation(.default, value: model.inputEdges)
            .animation(.default, value: Set(model.nodes.keys))
        }
        .coordinateSpace(coordinateSpace)
    }
    
    @ViewBuilder
    private func toolbar(for id: UUID, in coordinateSpace: some CoordinateSpaceProtocol) -> some View {
        Button {
            model.removeNode(id: id)
        } label: {
            Image(systemName: "multiply")
        }
        .buttonStyle(.plain)
    }
    
    @ViewBuilder
    private func dock(for id: UUID, edge: Edge) -> some View {
        let key = (id: id, edge: edge)
        Button {
            newNodePopover = key
        } label: {
            Image(systemName: "plus.circle")
        }
        .buttonStyle(.plain)
        .popover(isPresented: Binding {
            newNodePopover?.id == id && newNodePopover?.edge == edge
        } set: {
            newNodePopover = $0 ? key : nil
        }, arrowEdge: edge.opposite) {
            VStack {
                ForEach(SynthesizerNodeType.allCases, id: \.self) { type in
                    Button(type.name) {
                        model.insertNode(around: id, at: edge, .init(type: type))
                    }
                }
            }
            .padding()
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
