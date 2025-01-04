//
//  SynthesizerChartView.swift
//  Sineweaver
//
//  Created on 25.12.24
//

import SwiftUI

struct SynthesizerChartView<Node>: View where Node: SynthesizerNodeProtocol {
    let node: Node
    var animated: Bool = false
    var displaySampleRate: Double = 9_000
    var displayInterval: TimeInterval = 0.05
    var displayAmplitude: Double = 1.05
    var animationSpeed: Double = 1

    @State private var referenceDate = Date()
    
    var body: some View {
        if animated {
            TimelineView(.animation) { context in
                chart(for: context.date)
            }
        } else {
            chart(for: referenceDate)
        }
    }
    
    @ViewBuilder
    private func chart(for date: Date) -> some View {
        ChartView(yRange: -displayAmplitude..<displayAmplitude, sampleCount: Int(displaySampleRate * displayInterval)) { output in
            var state = node.makeState()
            node.render(inputs: [], output: &output, state: &state, context: .init(
                frame: Int(date.timeIntervalSince(referenceDate) * displaySampleRate * animationSpeed),
                sampleRate: Double(displaySampleRate * animationSpeed)
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
