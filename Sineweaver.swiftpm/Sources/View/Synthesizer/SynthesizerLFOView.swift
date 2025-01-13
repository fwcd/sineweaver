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
    
    @State private var initialNodeScale: Double? = nil

    var body: some View {
        let size = ComponentDefaults.padSize / 2
        HStack(spacing: SynthesizerViewDefaults.hSpacing) {
            let displayInterval: TimeInterval = 1
            TimelineView(.animation) { context in
                SynthesizerChartView(
                    node: node,
                    timeInterval: context.date.timeIntervalSince(startDate) - displayInterval,
                    displaySampleRate: 100,
                    displayInterval: displayInterval,
                    displayRange: 0..<1,
                    markedSample: .last
                )
                .frame(width: size, height: size)
            }
            .gesture(
                DragGesture()
                    .onChanged { drag in
                        if initialNodeScale == nil {
                            initialNodeScale = node.scale
                        }
                        node.scale = initialNodeScale! - 2 * Double(drag.translation.height / size)
                    }
                    .onEnded { _ in
                        initialNodeScale = nil
                    }
            )
            VStack {
                LabelledKnob(value: $node.frequency.logarithmic, range: log(0.01)...log(100), text: "Frequency") { _ in
                    String(format: "%.2f Hz", node.frequency)
                }
                EnumPicker(selection: $node.wave, label: Text("Wave"))
            }
        }
    }
}

#Preview {
    @Previewable @State var node = LFONode()
    
    SynthesizerLFOView(node: $node)
}
