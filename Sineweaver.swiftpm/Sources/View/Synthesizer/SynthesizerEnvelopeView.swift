//
//  SynthesizerEnvelopeView.swift
//  Sineweaver
//
//  Created on 05.01.25
//

import SwiftUI

struct SynthesizerEnvelopeView: View {
    @Binding var node: EnvelopeNode
    var duration: Duration = .milliseconds(50)
    
    private var millisRange: ClosedRange<Double> { 0...duration.asMilliseconds }
    private var volumeRange: ClosedRange<Double> { 0...1 }
    
    var body: some View {
        let sustainDummyMs: Double = 10
        VStack(spacing: SynthesizerViewDefaults.vSpacing) {
            MultiSlider2D(
                width: 300,
                height: 120,
                thumbPositions: Binding<[Vec2<Double>]> {
                    [
                        .init(x: 0, y: 0),
                        .init(x: node.attackMs, y: 1),
                        .init(x: node.attackMs + node.decayMs, y: node.sustain),
                        .init(x: node.attackMs + node.decayMs + sustainDummyMs, y: node.sustain),
                        .init(x: node.attackMs + node.decayMs + sustainDummyMs + node.releaseMs, y: 0),
                    ]
                } set: {
                    assert($0.count == 5)
                    node.attackMs = max(0, $0[1].x)
                    node.decayMs = max(0, $0[2].x - $0[1].x)
                    node.sustain = (0...1).clamp($0[3].y != node.sustain ? $0[3].y : $0[2].y)
                    node.releaseMs = max(0, $0[4].x - $0[3].x)
                },
                thumbOptions: [
                    .init(enabledAxes: .init(x: false, y: false)),
                    .init(enabledAxes: .init(x: true, y: false)),
                    .init(),
                    .init(enabledAxes: .init(x: false, y: true)),
                    .init(enabledAxes: .init(x: true, y: false)),
                ],
                connectThumbs: true,
                axes: .init(
                    x: .init(range: millisRange),
                    y: .init(range: volumeRange)
                ),
                background: .clear
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
