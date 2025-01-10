//
//  SynthesizerNodeView.swift
//  Sineweaver
//
//  Created on 27.12.24
//

import SwiftUI

struct SynthesizerNodeView<Toolbar>: View where Toolbar: View {
    @Binding var node: SynthesizerNode
    var startDate: Date = Date()
    var isActive: Bool = false
    @ViewBuilder var toolbar: () -> Toolbar

    private var hasBox: Bool {
        switch node {
        case .mixer: false
        default: true
        }
    }
    
    var body: some View {
        if hasBox {
            ComponentBox {
                inner
            } label: {
                Text(node.name)
            } toolbar: {
                toolbar()
            } dock: { alignment in
                // TODO
            }
        } else {
            inner
        }
    }
    
    @ViewBuilder
    private var inner: some View {
        VStack(alignment: .trailing) {
            switch node {
            case .oscillator:
                SynthesizerOscillatorView(node: $node.asOscillator)
            case .lfo:
                SynthesizerLFOView(node: $node.asLFO, startDate: startDate)
            case .filter:
                SynthesizerFilterView(node: $node.asFilter)
            case .envelope:
                SynthesizerEnvelopeView(node: $node.asEnvelope, isActive: isActive)
            case .mixer:
                SynthesizerMixerView(node: $node.asMixer)
            default:
                Text("TODO")
            }
        }
    }
}

extension SynthesizerNodeView where Toolbar == EmptyView {
    init(
        node: Binding<SynthesizerNode>,
        startDate: Date = Date(),
        isActive: Bool = false
    ) {
        self.init(
            node: node,
            startDate: startDate,
            isActive: isActive
        ) {}
    }
}

#Preview {
    @Previewable @State var node = SynthesizerNode.oscillator(.init())
    
    SynthesizerNodeView(node: $node)
}
