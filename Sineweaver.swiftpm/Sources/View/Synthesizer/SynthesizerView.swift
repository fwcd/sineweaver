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
            ForEach(tnodes) { tnode in
                ComponentBox(tnode.node.name) {
                    SynthesizerNodeView(
                        node: $model.nodes[tnode.id].unwrapped,
                        startDate: startDate,
                        isActive: model.isActive
                    )
                    .fixedSize()
                }
            }
            level()
        }
    }
}
