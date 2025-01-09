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
    @ViewBuilder var level: () -> Level
    
    @State private var hovered: Set<UUID> = []
    @State private var offsets: [UUID: CGSize] = [:]
    
    var body: some View {
        HStack {
            let coordinateSpace: NamedCoordinateSpace = .named("SynthesizerView")
            
            let tnodes: [ToposortedNode] = model.toposortedNodes
                .filter { !hiddenNodeIds.contains($0.id) }
            let groups = Dictionary(grouping: tnodes, by: \.depth)
                .sorted { $0.key > $1.key }
                .map { (id: $0.value.first?.id, group: $0.value) }
            
            ForEach(groups, id: \.id) { (_, group) in
                VStack(alignment: .trailing) {
                    ForEach(group) { (tnode: ToposortedNode) in
                        SynthesizerNodeView(
                            node: $model.nodes[tnode.id].unwrapped,
                            startDate: startDate,
                            isActive: model.isActive
                        ) {
                            if allowsEditing && hovered.contains(tnode.id) {
                                HStack(spacing: 10) {
                                    Image(systemName: "line.3.horizontal")
                                        .contentShape(Rectangle())
                                        .gesture(
                                            DragGesture(minimumDistance: 0, coordinateSpace: coordinateSpace)
                                                .onChanged { value in
                                                    offsets[tnode.id] = value.translation
                                                }
                                                .onEnded { _ in
                                                    offsets[tnode.id] = nil
                                                }
                                        )
                                    Button {
                                        model.removeNode(id: tnode.id)
                                    } label: {
                                        Image(systemName: "x.circle")
                                    }
                                }
                                .buttonStyle(PlainButtonStyle())
                                .padding(.bottom, 5)
                            }
                        }
                        .fixedSize()
                        .offset(offsets[tnode.id] ?? CGSize())
                        .onHover { over in
                            if over {
                                hovered.insert(tnode.id)
                            } else {
                                hovered.remove(tnode.id)
                            }
                        }
                    }
                }
            }
            .coordinateSpace(coordinateSpace)
            .animation(.default, value: model.inputEdges)
            .animation(.default, value: Set(model.nodes.keys))
            level()
        }
    }
}

#Preview(traits: .landscapeLeft) {
    @Previewable @State var model = SynthesizerModel()
    
    SynthesizerView(model: $model, allowsEditing: true) {}
        .onAppear {
            SynthesizerChapter.allCases.last!.configure(synthesizer: &model)
        }
}
