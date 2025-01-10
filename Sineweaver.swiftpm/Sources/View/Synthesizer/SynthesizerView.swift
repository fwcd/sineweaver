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
    @State private var newNodePopovers: Set<UUID> = []
    @State private var activeDragOffsets: [UUID: CGSize] = [:]
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
                        if !activeDragOffsets.keys.contains(id),
                           !activeDragOffsets.keys.contains(inputId),
                           let frame = frames[id],
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
                            SynthesizerNodeView(
                                node: $model.nodes[id].unwrapped,
                                startDate: startDate,
                                isActive: model.isActive
                            ) {
                                if allowsEditing && hovered.contains(id) {
                                    toolbar(for: id, in: coordinateSpace)
                                        .padding(.bottom, 5)
                                }
                            }
                            .background(FrameReader(in: coordinateSpace) { frame in
                                frames[id] = frame
                            })
                            .fixedSize()
                            .background(activeDragOffsets.keys.contains(id) ? AnyShapeStyle(.ultraThinMaterial) : AnyShapeStyle(.clear))
                            .zIndex(activeDragOffsets.keys.contains(id) ? 2 : 1)
                            .offset(activeDragOffsets[id] ?? CGSize())
                            .onHover { over in
                                if over {
                                    hovered.insert(id)
                                } else {
                                    hovered.remove(id)
                                }
                            }
                        }
                    }
                    .zIndex(Set(activeDragOffsets.keys).isDisjoint(with: group.map(\.id)) ? 1 : 2)
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
        HStack(spacing: 10) {
            Image(systemName: "line.3.horizontal")
                .contentShape(Rectangle())
                .gesture(
                    DragGesture(minimumDistance: 0, coordinateSpace: coordinateSpace)
                        .onChanged { value in
                            activeDragOffsets[id] = value.translation
                        }
                        .onEnded { _ in
                            Task {
                                // A small workaround to avoid having the FrameReader's onChanged fire multiple times during a single SwiftUI frame
                                try? await Task.sleep(for: .milliseconds(10))
                                activeDragOffsets[id] = nil
                            }
                        }
                )
            Button {
                model.removeNode(id: id)
            } label: {
                Image(systemName: "x.circle")
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview(traits: .landscapeLeft) {
    @Previewable @State var model = SynthesizerModel()
    
    SynthesizerView(model: $model, allowsEditing: true) {}
        .onAppear {
            SynthesizerChapter.allCases.last!.configure(synthesizer: &model)
        }
}
