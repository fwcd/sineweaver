//
//  SynthesizerView.swift
//  Sineweaver
//
//  Created on 27.12.24
//

import SwiftUI

struct SynthesizerView: View {
    @Environment(SynthesizerViewModel.self) private var viewModel
    
    var body: some View {
        let model = viewModel.synthesizer.model.lock().wrappedValue
        ForEach(model.nodes.sorted { $0.key < $1.key }, id: \.key) { node in
            ComponentBox(node.value.type.name) {
                // TODO: Binding
                SynthesizerNodeView(node: .constant(node.value))
            }
        }
    }
}
