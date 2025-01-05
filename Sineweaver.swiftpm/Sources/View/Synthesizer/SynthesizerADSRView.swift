//
//  SynthesizerADSRView.swift
//  Sineweaver
//
//  Created on 05.01.25
//

import SwiftUI

struct SynthesizerADSRView: View {
    @Binding var attackMs: Double
    @Binding var decayMs: Double
    @Binding var sustain: Double
    @Binding var releaseMs: Double
    var millisRange: ClosedRange<Double> = 0...SynthesizerViewDefaults.durationMs
    var volumeRange: ClosedRange<Double> = 0...1

    var body: some View {
        let sustainDummyMs: Double = millisRange.length / 8
        MultiSlider2D(
            width: 300,
            height: 120,
            thumbPositions: Binding<[Vec2<Double>]> {
                [
                    .init(x: 0, y: 0),
                    .init(x: attackMs, y: 1),
                    .init(x: attackMs + decayMs, y: sustain),
                    .init(x: attackMs + decayMs + sustainDummyMs, y: sustain),
                    .init(x: attackMs + decayMs + sustainDummyMs + releaseMs, y: 0),
                ]
            } set: {
                assert($0.count == 5)
                attackMs = max(0, $0[1].x)
                decayMs = max(0, $0[2].x - $0[1].x)
                sustain = (0...1).clamp($0[3].y != sustain ? $0[3].y : $0[2].y)
                releaseMs = max(0, $0[4].x - $0[3].x)
            },
            thumbOptions: [
                .init(enabledAxes: .init(x: false, y: false)),
                .init(enabledAxes: .init(x: true, y: false)),
                .init(),
                .init(enabledAxes: .init(x: false, y: true)),
                .init(enabledAxes: .init(x: true, y: false)),
            ],
            thumbCurve: .init(stroke: true, fill: true),
            axes: .init(
                x: .init(range: millisRange),
                y: .init(range: volumeRange)
            ),
            background: .clear
        )
    }
}

#Preview {
    @Previewable @State var node = EnvelopeNode()

    SynthesizerADSRView(
        attackMs: $node.attackMs,
        decayMs: $node.decayMs,
        sustain: $node.sustain,
        releaseMs: $node.releaseMs
    )
}
