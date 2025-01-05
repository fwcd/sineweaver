//
//  SynthesizerADSRCurveView.swift
//  Sineweaver
//
//  Created on 05.01.25
//

import SwiftUI

struct SynthesizerADSRCurveView: View {
    @Binding var attackMs: Double
    @Binding var decayMs: Double
    @Binding var sustain: Double
    @Binding var releaseMs: Double
    var millisRange: ClosedRange<Double> = 0...SynthesizerViewDefaults.durationMs
    var volumeRange: ClosedRange<Double> = 0...1
    var highlightMs: Double? = nil
    var isActive = false
    
    private var highlightPosition: Double? {
        guard var ms = highlightMs else { return nil }
        if isActive {
            if ms < attackMs {
                return ms / attackMs
            }
            ms -= attackMs
            if ms < decayMs {
                return 1 + ms / decayMs
            }
            ms -= decayMs
            return 2
        } else {
            if ms < releaseMs {
                return 3 + ms / releaseMs
            }
            return nil
        }
    }

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
                attackMs = max(0, min($0[1].x, $0[2].x) - ($0[1].x == $0[2].x ? max(0, $0[3].x - $0[4].x) : 0))
                decayMs = max(0, max($0[2].x - $0[1].x, $0[1].x - $0[2].x) - max(0, $0[3].x - $0[4].x))
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
            thumbCurve: .init(stroke: true, fill: true, highlightPosition: highlightPosition),
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

    SynthesizerADSRCurveView(
        attackMs: $node.attackMs,
        decayMs: $node.decayMs,
        sustain: $node.sustain,
        releaseMs: $node.releaseMs
    )
}
