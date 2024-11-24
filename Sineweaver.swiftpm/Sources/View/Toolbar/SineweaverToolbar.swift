//
//  SineweaverToolbar.swift
//  Sineweaver
//
//  Created on 24.11.24
//

import SwiftUI

struct SineweaverToolbar: View {
    @EnvironmentObject private var synthesizer: Synthesizer
    
    var body: some View {
        HStack {
            Button {
                synthesizer.model.lock().useValue { model in
                    let nodeId = model.add(node: .sine(.init()))
                    if let outputId = model.outputNodeId {
                        model.connect(nodeId, to: outputId)
                    }
                }
            } label: {
                Label("Add Node", systemImage: "plus")
            }
        }
        .buttonStyle(.borderedProminent)
    }
}
