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
                VStack {
                    Knob(value: $node.attackMs, range: millisRange)
                    ComponentLabel("Attack")
                }
                VStack {
                    Knob(value: $node.decayMs, range: millisRange)
                    ComponentLabel("Decay")
                }
                VStack {
                    Knob(value: $node.sustain, range: volumeRange)
                    ComponentLabel("Sustain")
                }
                VStack {
                    Knob(value: $node.releaseMs, range: millisRange)
                    ComponentLabel("Release")
                }
            }
        }
        .clipped()
    }
}

#Preview {
    @Previewable @State var node = EnvelopeNode()

    SynthesizerEnvelopeView(node: $node)
}
