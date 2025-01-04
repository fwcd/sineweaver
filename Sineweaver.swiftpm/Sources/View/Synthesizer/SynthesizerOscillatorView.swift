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
        VStack(spacing: 15) {
            HStack(spacing: 20) {
                SynthesizerChartView(node: playingNode)
                    .opacity(node.isPlaying ? 1 : 0.5)
                    .overlay(alignment: .bottom) {
                        Text(String(format: "%d Hz (%.2f dB)", Int(node.frequency), 10 * log10(node.volume)))
                            .font(.system(size: 14).monospacedDigit())
                            .padding(10)
                            .background(.ultraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .opacity(node.isPlaying ? 1 : 0)
                            .animation(.default, value: node.isPlaying)
                    }
                Slider2D(
                    size: node.prefersPianoView ? 100 : 200,
                    x: $node.frequency.logarithmic,
                    in: log(20)...log(20000),
                    label: "Frequency",
                    y: $node.volume,
                    in: 0...1,
                    label: "Volume"
                ) { isPressed in
                    node.isPlaying = isPressed
                }
                .font(node.prefersPianoView ? .system(size: 8) : nil)
            }
            if node.prefersPianoView {
                PianoView(notes: Note(.c, 3)..<Note(.c, 6)) { notes in
                    if let note = notes.first {
                        node.frequency = EqualTemperament().pitchHz(for: note)
                    }
                    node.isPlaying = !notes.isEmpty
                }
            }
        }
        .frame(maxWidth: 600)
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
