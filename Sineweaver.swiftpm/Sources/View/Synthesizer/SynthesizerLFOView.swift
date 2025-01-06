//
//  SynthesizerLFOView.swift
//  Sineweaver
//
//  Created on 25.12.24
//

import SwiftUI

struct SynthesizerLFOView: View {
    @Binding var node: LFONode
    var startDate: Date = Date()

    var body: some View {
        let size = ComponentDefaults.padSize / 2
        VStack(spacing: SynthesizerViewDefaults.vSpacing) {
            let displayInterval: TimeInterval = 1
            TimelineView(.animation) { context in
                SynthesizerChartView(
                    node: node,
                    timeInterval: context.date.timeIntervalSince(startDate) - displayInterval,
                    displaySampleRate: 30,
                    displayInterval: displayInterval,
                    displayRange: -0.05..<1.05,
                    markedSample: .last
                )
                .frame(width: size, height: size)
            }
            LabelledKnob(value: $node.frequency, range: 0.01...1, text: "Frequency") {
                String(format: "%.2f Hz", $0)
            }
        }
    }
}

#Preview {
    @Previewable @State var node = LFONode()
    
    SynthesizerLFOView(node: $node)
}
