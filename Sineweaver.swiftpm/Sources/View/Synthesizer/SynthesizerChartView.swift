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
    var displaySampleRate: Double = SynthesizerViewDefaults.chartDisplaySampleRate
    var displayInterval: TimeInterval = SynthesizerViewDefaults.chartDisplayInterval
    var displayRange: Range<Double> = SynthesizerViewDefaults.chartDisplayRange
    var markedSample: MarkedSample? = nil
    
    enum MarkedSample: Hashable {
        case first
        case last
        case custom(Int)
        
        func index(for sampleCount: Int) -> Int {
            switch self {
            case .first: 0
            case .last: sampleCount - 1
            case let .custom(i): i
            }
        }
    }
    
    var body: some View {
        let sampleCount = Int(displaySampleRate * displayInterval)
        let markedSample = markedSample?.index(for: sampleCount)
        ChartView(yRange: displayRange, sampleCount: sampleCount, markedSample: markedSample) { output in
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
            SynthesizerChartView(node: OscillatorNode(wave: wave, frequencies: [40]))
                .frame(maxHeight: 100)
        }
    }
}
