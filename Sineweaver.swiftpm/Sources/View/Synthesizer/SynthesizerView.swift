//
//  SynthesizerView.swift
//  Sineweaver
//
//  Created on 27.12.24
//

import SwiftUI

struct SynthesizerView: View {
    @Binding var model: SynthesizerModel
    var hiddenNodeIds: Set<UUID> = []
    
    var body: some View {
        HStack {
            let nodes = model.toposortedNodes.filter { !hiddenNodeIds.contains($0.id) }
            ForEach(nodes, id: \.id) { (id, node) in
                ComponentBox(node.type.name) {
                    SynthesizerNodeView(node: $model.nodes[id].unwrapped, isActive: model.isActive)
                }
            }
        }
    }
}
