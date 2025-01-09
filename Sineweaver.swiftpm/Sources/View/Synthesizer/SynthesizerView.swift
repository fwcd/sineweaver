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
    @State private var frames: [UUID: CGRect] = [:]

    var body: some View {
        let coordinateSpace: NamedCoordinateSpace = .named("SynthesizerView")
        
        HStack {
            let tnodes: [ToposortedNode] = model.toposortedNodes
                .filter { !hiddenNodeIds.contains($0.id) }
            let groups = Dictionary(grouping: tnodes, by: \.depth)
                .sorted { $0.key > $1.key }
                .map { (id: $0.value.first?.id, group: $0.value) }
            
            ForEach(groups, id: \.id) { (_, group) in
                VStack(alignment: .trailing) {
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
                        .background(
                            GeometryReader { proxy in
                                let frame = proxy.frame(in: coordinateSpace)
                                Color.clear
                                    .onAppear {
                                        frames[id] = frame
                                    }
                                    .onChange(of: frame.origin) {
                                        frames[id] = frame
                                    }
                            }
                        )
                        .fixedSize()
                        .background(offsets.keys.contains(id) ? AnyShapeStyle(.ultraThinMaterial) : AnyShapeStyle(.clear))
                        .zIndex(offsets.keys.contains(id) ? 2 : 1)
                        .offset(offsets[id] ?? CGSize())
                        .onHover { over in
                            if over {
                                hovered.insert(id)
                            } else {
                                hovered.remove(id)
                            }
                        }
                    }
                }
                .zIndex(Set(offsets.keys).isDisjoint(with: group.map(\.id)) ? 1 : 2)
            }
            level()
        }
        .coordinateSpace(coordinateSpace)
        .animation(.default, value: model.inputEdges)
        .animation(.default, value: Set(model.nodes.keys))
        .overlay {
            ZStack(alignment: .topLeading) {
                ForEach(Array(frames), id: \.key) { (id, frame) in
                    Rectangle()
                        .fill(.red.opacity(0.3))
                        .frame(width: frame.size.width, height: frame.size.height)
                        .position(x: frame.midX, y: frame.midY)
                }
            }
            .allowsHitTesting(false)
        }
    }
    
    @ViewBuilder
    private func toolbar(for id: UUID, in coordinateSpace: some CoordinateSpaceProtocol) -> some View {
        HStack(spacing: 10) {
            Image(systemName: "line.3.horizontal")
                .contentShape(Rectangle())
                .gesture(
                    DragGesture(minimumDistance: 0, coordinateSpace: coordinateSpace)
                        .onChanged { value in
                            offsets[id] = value.translation
                        }
                        .onEnded { _ in
                            offsets[id] = nil
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
