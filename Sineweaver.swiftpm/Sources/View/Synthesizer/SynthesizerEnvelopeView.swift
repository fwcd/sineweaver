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
                let attack = $0[1].x
                let decay = $0[2].x - $0[1].x
                let sustain = $0[2].y
                let release = $0[4].x - $0[3].x
                
                if attack >= 0 && decay >= 0 && (0...1).contains(sustain) && release >= 0 {
                    node.attack.asMilliseconds = attack
                    node.decay.asMilliseconds = decay
                    node.sustain = sustain
                    node.release.asMilliseconds = release
                }
            },
            thumbOptions: [
                .init(enabledAxes: .init(x: true, y: false)),
                .init(),
                .init(),
                .init(enabledAxes: .init(x: false, y: false)),
                .init(),
            ],
            connectThumbs: true,
            axes: .init(
                x: .init(range: 0...duration.asMilliseconds),
                y: .init(range: 0...1)
            ),
            background: ComponentDefaults.padBackground
        )
    }
}

#Preview {
    @Previewable @State var node = EnvelopeNode(attack: .milliseconds(10), decay: .milliseconds(10))

    SynthesizerEnvelopeView(node: $node)
}
