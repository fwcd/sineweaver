//
//  SynthesizerEnvelopeView.swift
//  Sineweaver
//
//  Created on 05.01.25
//

import SwiftUI

struct SynthesizerEnvelopeView: View {
    @Binding var node: EnvelopeNode
    
    var durationMs: Double = SynthesizerViewDefaults.durationMs
    
    var millisRange: ClosedRange<Double> { 0...durationMs }
    var volumeRange: ClosedRange<Double> { 0...1 }

    var body: some View {
        VStack(spacing: SynthesizerViewDefaults.vSpacing) {
            SynthesizerADSRView(
                attackMs: $node.attackMs,
                decayMs: $node.decayMs,
                sustain: $node.sustain,
                releaseMs: $node.releaseMs,
                millisRange: millisRange,
                volumeRange: volumeRange
            )
            .padding()
            HStack(spacing: SynthesizerViewDefaults.hSpacing) {
                knob(value: $node.attackMs, range: millisRange, label: "Attack")
                knob(value: $node.decayMs, range: millisRange, label: "Decay")
                knob(value: $node.sustain, range: volumeRange, label: "Sustain")
                knob(value: $node.releaseMs, range: millisRange, label: "Release")
            }
        }
        .clipped()
    }
    
    @ViewBuilder
    private func knob(value: Binding<Double>, range: ClosedRange<Double>, label: String) -> some View {
        VStack {
            Knob(value: value, range: range)
            ComponentLabel(label)
        }
    }
}

#Preview {
    @Previewable @State var node = EnvelopeNode()

    SynthesizerEnvelopeView(node: $node)
}
