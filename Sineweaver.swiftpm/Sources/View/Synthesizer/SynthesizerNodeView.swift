//
//  SynthesizerNodeView.swift
//  Sineweaver
//
//  Created on 27.12.24
//

import SwiftUI

struct SynthesizerNodeView: View {
    @Binding var node: SynthesizerNode
    var startDate: Date = Date()
    var isActive: Bool = false
    
    private var hasBox: Bool {
        switch node {
        case .mixer: false
        default: true
        }
    }
    
    var body: some View {
        if hasBox {
            ComponentBox(node.name) {
                inner
            }
        } else {
            inner
        }
    }
    
    @ViewBuilder
    private var inner: some View {
        switch node {
        case .oscillator:
            SynthesizerOscillatorView(node: $node.asOscillator)
        case .lfo:
            SynthesizerLFOView(node: $node.asLFO, startDate: startDate)
        case .envelope:
            SynthesizerEnvelopeView(node: $node.asEnvelope, isActive: isActive)
        case .mixer:
            SynthesizerMixerView(node: $node.asMixer)
        default:
            Text("TODO")
        }
    }
}

#Preview {
    @Previewable @State var node = SynthesizerNode.oscillator(.init())
    
    SynthesizerNodeView(node: $node)
}
