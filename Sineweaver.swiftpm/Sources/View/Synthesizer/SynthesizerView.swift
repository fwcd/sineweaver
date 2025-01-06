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
                .map { (id: $0.value.first?.id, group: $0.value) }
            ForEach(groups, id: \.id) { (_, group) in
                VStack(alignment: .trailing) {
                    ForEach(group) { tnode in
                        SynthesizerNodeView(
                            node: $model.nodes[tnode.id].unwrapped,
                            startDate: startDate,
                            isActive: model.isActive
                        )
                        .fixedSize()
                    }
                }
            }
            level()
        }
    }
}
