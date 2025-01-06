//
//  SynthesizerChartView.swift
//  Sineweaver
//
//  Created on 25.12.24
//

import SwiftUI

struct SynthesizerChartView<Node>: View where Node: SynthesizerNodeProtocol {
    let node: Node
    var timeInterval: TimeInterval = 0
    var displaySampleRate: Double = 9_000
    var displayInterval: TimeInterval = 0.05
    var displayAmplitude: Double = 1.05
    
    var body: some View {
        ChartView(yRange: -displayAmplitude..<displayAmplitude, sampleCount: Int(displaySampleRate * displayInterval)) { output in
            var state = node.makeState()
            node.render(inputs: [], output: &output, state: &state, context: .init(
                frame: Int(timeInterval * displaySampleRate),
                sampleRate: Double(displaySampleRate)
            ))
        }
    }
}

#Preview {
    VStack(spacing: 50) {
        ForEach(OscillatorNode.Wave.allCases, id: \.self) { wave in
            SynthesizerChartView(node: OscillatorNode(wave: wave, frequency: 40))
                .frame(maxHeight: 100)
        }
    }
}
