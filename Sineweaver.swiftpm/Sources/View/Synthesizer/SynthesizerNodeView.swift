//
//  SynthesizerNodeView.swift
//  Sineweaver
//
//  Created on 27.12.24
//

import SwiftUI

struct SynthesizerNodeView: View {
    @Binding var node: SynthesizerNode
    var isActive: Bool = false
    
    var body: some View {
        switch node {
        case .oscillator:
            SynthesizerOscillatorView(node: $node.asOscillator)
        case .lfo:
            SynthesizerLFOView(node: $node.asLFO)
        case .envelope:
            SynthesizerEnvelopeView(node: $node.asEnvelope, isActive: isActive)
        default:
            Text("TODO")
        }
    }
}

#Preview {
    @Previewable @State var node = SynthesizerNode.oscillator(.init())
    
    SynthesizerNodeView(node: $node)
}
