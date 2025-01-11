//
//  SynthesizerNodeView.swift
//  Sineweaver
//
//  Created on 27.12.24
//

import SwiftUI

struct SynthesizerNodeView<Toolbar, Handle>: View where Toolbar: View, Handle: View {
    @Binding var node: SynthesizerNode
    var startDate: Date = Date()
    var isActive: Bool = false
    var allowsEditing: Bool = true
    @ViewBuilder var toolbar: () -> Toolbar
    @ViewBuilder var handle: (Edge) -> Handle

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
        } handle: { edge in
            handle(edge)
        }
    }
    
    @ViewBuilder
    private var inner: some View {
        VStack(alignment: .trailing) {
            switch node {
            case .oscillator:
                SynthesizerOscillatorView(node: $node.asOscillator, allowsEditing: allowsEditing)
            case .lfo:
                SynthesizerLFOView(node: $node.asLFO, startDate: startDate)
            case .noise:
                SynthesizerNoiseView(node: $node.asNoise)
            case .filter:
                SynthesizerFilterView(node: $node.asFilter, allowsEditing: allowsEditing)
            case .envelope:
                SynthesizerEnvelopeView(node: $node.asEnvelope, isActive: isActive)
            case .mixer:
                SynthesizerMixerView(node: $node.asMixer, allowsEditing: allowsEditing)
            case .controller:
                SynthesizerControllerView(node: $node.asController)
            default:
                Text("this node has no UI")
                    .italic()
                    .opacity(0.5)
            }
        }
    }
}

extension SynthesizerNodeView where Toolbar == EmptyView, Handle == EmptyView {
    init(
        node: Binding<SynthesizerNode>,
        startDate: Date = Date(),
        isActive: Bool = false
    ) {
        self.init(
            node: node,
            startDate: startDate,
            isActive: isActive
        ) {} handle: { _ in }
    }
}

#Preview {
    @Previewable @State var node = SynthesizerNode.oscillator(.init())
    
    SynthesizerNodeView(node: $node)
}
