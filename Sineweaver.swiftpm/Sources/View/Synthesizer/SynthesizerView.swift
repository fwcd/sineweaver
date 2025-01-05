//
//  SynthesizerView.swift
//  Sineweaver
//
//  Created on 27.12.24
//

import SwiftUI

struct SynthesizerView: View {
    @Binding var model: SynthesizerModel
    
    var body: some View {
        HStack {
            // TODO: Sort these topologically
            ForEach(model.nodes.sorted { $0.key < $1.key }, id: \.key) { node in
                ComponentBox(node.value.type.name) {
                    let key: UUID = node.key
                    SynthesizerNodeView(node: $model.nodes[key].unwrapped)
                }
            }
        }
    }
}
