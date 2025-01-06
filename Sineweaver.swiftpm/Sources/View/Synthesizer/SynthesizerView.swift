//
//  SynthesizerView.swift
//  Sineweaver
//
//  Created on 27.12.24
//

import SwiftUI

struct SynthesizerView<Level>: View where Level: View {
    @Binding var model: SynthesizerModel
    var startDate: Date = Date()
    var hiddenNodeIds: Set<UUID> = []
    @ViewBuilder var level: () -> Level
    
    var body: some View {
        HStack {
            let tnodes = model.toposortedNodes
                .filter { !hiddenNodeIds.contains($0.id) }
            let groups = Dictionary(grouping: tnodes, by: \.depth)
                .sorted { $0.key > $1.key }
            ForEach(Array(groups.enumerated()), id: \.offset) { (_, group) in
                VStack(alignment: .trailing) {
                    ForEach(group.value) { tnode in
                        ComponentBox(tnode.node.name) {
                            SynthesizerNodeView(
                                node: $model.nodes[tnode.id].unwrapped,
                                startDate: startDate,
                                isActive: model.isActive
                            )
                            .fixedSize()
                        }
                    }
                }
            }
            level()
        }
    }
}
