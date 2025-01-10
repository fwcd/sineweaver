//
//  SynthesizerMixerView.swift
//  Sineweaver
//
//  Created on 06.01.25
//

import SwiftUI

struct SynthesizerMixerView: View {
    @Binding var node: MixerNode
    
    var body: some View {
        let icon = switch node.operation {
        case .sum: "plus"
        case .product: "multiply"
        }
        Image(systemName: icon)
    }
}

#Preview {
    VStack {
        ForEach(MixerNode.Operation.allCases, id: \.self) { operation in
            SynthesizerMixerView(node: .constant(.init(operation: operation)))
        }
    }
}
