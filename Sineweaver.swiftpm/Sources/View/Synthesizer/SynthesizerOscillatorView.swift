//
//  SynthesizerOscillatorView.swift
//  Sineweaver
//
//  Created on 25.12.24
//

import SwiftUI

struct SynthesizerOscillatorView: View {
    @Binding var node: OscillatorNode
    
    private var playingNode: OscillatorNode {
        var node = node
        node.isPlaying = true
        return node
    }
    
    var body: some View {
        HStack(spacing: 20) {
            SynthesizerChartView(node: playingNode)
                .opacity(node.isPlaying ? 1 : 0.5)
                .frame(minWidth: 300)
            Slider2D(
                x: $node.frequency.logarithmic,
                in: log(20)...log(20000),
                label: "Frequency",
                y: $node.volume,
                in: 0...1,
                label: "Volume"
            ) { isPressed in
                node.isPlaying = isPressed
            }
        }
    }
}

#Preview {
    @Previewable @State var nodes = OscillatorNode.Wave.allCases.map { OscillatorNode(wave: $0, frequency: 40) }
    
    VStack(spacing: 50) {
        ForEach(Array(nodes.indices), id: \.self) { i in
            SynthesizerOscillatorView(node: $nodes[i])
                .frame(maxHeight: 100)
        }
    }
}
