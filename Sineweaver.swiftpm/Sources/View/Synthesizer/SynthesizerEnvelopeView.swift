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
    
    var body: some View {
        let sustainDummy: Duration = .milliseconds(10)
        MultiSlider2D(
            thumbPositions: Binding<[Vec2<Double>]> {
                [
                    .init(x: 0, y: 0),
                    .init(x: node.attack.asMilliseconds, y: 1),
                    .init(x: (node.attack + node.decay).asMilliseconds, y: node.sustain),
                    .init(x: (node.attack + node.decay + sustainDummy).asMilliseconds, y: node.sustain),
                    .init(x: (node.attack + node.decay + sustainDummy + node.release).asMilliseconds, y: 0),
                ]
            } set: {
                assert($0.count == 5)
                let attack = max(0, $0[1].x)
                let decay = max(0, $0[2].x - $0[1].x)
                let sustain = (0...1).clamp($0[3].y != node.sustain ? $0[3].y : $0[2].y)
                let release = max(0, $0[4].x - $0[3].x)
                
                node.attack.asMilliseconds = attack
                node.decay.asMilliseconds = decay
                node.sustain = sustain
                node.release.asMilliseconds = release
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
                x: .init(range: 0...duration.asMilliseconds),
                y: .init(range: 0...1)
            ),
            background: .clear
        )
        .padding()
    }
}

#Preview {
    @Previewable @State var node = EnvelopeNode()

    SynthesizerEnvelopeView(node: $node)
}
