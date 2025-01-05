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
            // TODO: Sort these topologically
            let nodes = model.nodes
                .filter { !hiddenNodeIds.contains($0.key) }
                .sorted { $0.key < $1.key }
            ForEach(nodes, id: \.key) { node in
                ComponentBox(node.value.type.name) {
                    let key: UUID = node.key
                    SynthesizerNodeView(node: $model.nodes[key].unwrapped, isActive: model.isActive)
                }
            }
        }
    }
}
