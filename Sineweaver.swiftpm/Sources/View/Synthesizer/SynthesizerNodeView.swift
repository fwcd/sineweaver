//
//  SynthesizerNodeView.swift
//  Sineweaver
//
//  Created on 27.12.24
//

import SwiftUI

struct SynthesizerNodeView<Toolbar, Dock>: View where Toolbar: View, Dock: View {
    @Binding var node: SynthesizerNode
    var startDate: Date = Date()
    var isActive: Bool = false
    @ViewBuilder var toolbar: () -> Toolbar
    @ViewBuilder var dock: (Edge) -> Dock

    private var hasLabel: Bool {
        switch node {
        case .mixer: false
        default: true
        }
    }
    
    var body: some View {
        ComponentBox {
            inner
        } label: {
            if hasLabel {
                Text(node.name)
            }
        } toolbar: {
            toolbar()
        } dock: { edge in
            dock(edge)
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
                Text("this node has no UI")
                    .italic()
                    .opacity(0.5)
            }
        }
    }
}

extension SynthesizerNodeView where Toolbar == EmptyView, Dock == EmptyView {
    init(
        node: Binding<SynthesizerNode>,
        startDate: Date = Date(),
        isActive: Bool = false
    ) {
        self.init(
            node: node,
            startDate: startDate,
            isActive: isActive
        ) {} dock: { _ in }
    }
}

#Preview {
    @Previewable @State var node = SynthesizerNode.oscillator(.init())
    
    SynthesizerNodeView(node: $node)
}
