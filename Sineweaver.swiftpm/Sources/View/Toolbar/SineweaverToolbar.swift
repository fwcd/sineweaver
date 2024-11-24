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
            ForEach(SynthesizerNodeType.allCases, id: \.self) { nodeType in
                Button {
                    synthesizer.model.lock().useValue { model in
                        let nodeId = model.add(node: .init(type: nodeType))
                        if let outputId = model.outputNodeId {
                            model.connect(nodeId, to: outputId)
                        }
                    }
                } label: {
                    Label("Add \(nodeType.name)", systemImage: nodeType.iconName)
                }
            }
        }
        .buttonStyle(.borderedProminent)
    }
}
