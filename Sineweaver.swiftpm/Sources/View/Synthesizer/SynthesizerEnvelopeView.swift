//
//  SynthesizerEnvelopeView.swift
//  Sineweaver
//
//  Created on 05.01.25
//

import SwiftUI

struct SynthesizerEnvelopeView: View {
    @Binding var node: EnvelopeNode
    var isActive = false
    
    var durationMs: Double = SynthesizerViewDefaults.durationMs
    
    var millisRange: ClosedRange<Double> { 0...durationMs }
    var volumeRange: ClosedRange<Double> { 0...1 }
    
    @State private var activeChanged: Date? = nil

    var body: some View {
        VStack(spacing: SynthesizerViewDefaults.vSpacing) {
            TimelineView(.animation) { context in
                SynthesizerADSRCurveView(
                    attackMs: $node.attackMs,
                    decayMs: $node.decayMs,
                    sustain: $node.sustain,
                    releaseMs: $node.releaseMs,
                    millisRange: millisRange,
                    volumeRange: volumeRange,
                    highlightMs: activeChanged.map { context.date.timeIntervalSince($0) * 1000 },
                    isActive: isActive
                )
            }
            .padding()
            HStack(spacing: SynthesizerViewDefaults.hSpacing) {
                LabelledKnob(value: $node.attackMs, range: millisRange, text: "Attack", format: format(ms:))
                LabelledKnob(value: $node.decayMs, range: millisRange, text: "Decay", format: format(ms:))
                LabelledKnob(value: $node.sustain, range: volumeRange, text: "Sustain", format: format(volume:))
                LabelledKnob(value: $node.releaseMs, range: millisRange, text: "Release", format: format(ms:))
            }
        }
        .clipped()
        .onChange(of: isActive) {
            activeChanged = .now
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
