//
//  SynthesizerMixerView.swift
//  Sineweaver
//
//  Created on 06.01.25
//

import SwiftUI

struct SynthesizerMixerView: View {
    @Binding var node: MixerNode
    var allowsEditing = false
    
    var body: some View {
        let icon = switch node.operation {
        case .sum: "plus"
        case .product: "multiply"
        }
        Image(systemName: icon)
            .onTapGesture {
                if allowsEditing {
                    node.operation = switch node.operation {
                    case .sum: .product
                    case .product: .sum
                    }
                }
            }
    }
}

#Preview {
    VStack {
        ForEach(MixerNode.Operation.allCases, id: \.self) { operation in
            SynthesizerMixerView(node: .constant(.init(operation: operation)))
        }
    }
}
