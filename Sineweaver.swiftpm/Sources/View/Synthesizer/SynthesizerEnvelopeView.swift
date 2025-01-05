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
            SynthesizerADSRCurveView(
                attackMs: $node.attackMs,
                decayMs: $node.decayMs,
                sustain: $node.sustain,
                releaseMs: $node.releaseMs,
                millisRange: millisRange,
                volumeRange: volumeRange
            )
            .padding()
            HStack(spacing: SynthesizerViewDefaults.hSpacing) {
                knob(value: $node.attackMs, range: millisRange, label: "Attack", format: format(ms:))
                knob(value: $node.decayMs, range: millisRange, label: "Decay", format: format(ms:))
                knob(value: $node.sustain, range: volumeRange, label: "Sustain", format: format(volume:))
                knob(value: $node.releaseMs, range: millisRange, label: "Release", format: format(ms:))
            }
        }
        .clipped()
    }
    
    @ViewBuilder
    private func knob(value: Binding<Double>, range: ClosedRange<Double>, label: String, format: (Double) -> String) -> some View {
        VStack(spacing: SynthesizerViewDefaults.smallVSpacing) {
            Knob(value: value, range: range)
            ComponentLabel(label)
            ComponentLabel(format(value.wrappedValue), textCase: nil)
                .font(.system(size: 12))
        }
    }
    
    private func format(ms: Double) -> String {
        "\(Int(ms)) ms"
    }
    
    private func format(volume: Double) -> String {
        String(format: "%.2f dB", 10 * log10(volume))
    }
}

#Preview {
    @Previewable @State var node = EnvelopeNode()

    SynthesizerEnvelopeView(node: $node)
}
