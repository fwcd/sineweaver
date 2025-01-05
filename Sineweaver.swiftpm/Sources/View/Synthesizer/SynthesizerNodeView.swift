//
//  SynthesizerNodeView.swift
//  Sineweaver
//
//  Created on 27.12.24
//

import SwiftUI

struct SynthesizerNodeView: View {
    @Binding var node: SynthesizerNode
    
    var body: some View {
        switch node {
        case .oscillator:
            SynthesizerOscillatorView(node: $node.asOscillator)
        case .envelope:
            SynthesizerEnvelopeView(node: $node.asEnvelope)
        default:
            Text("TODO")
        }
    }
}

#Preview {
    @Previewable @State var node = SynthesizerNode.oscillator(.init())
    
    SynthesizerNodeView(node: $node)
}
