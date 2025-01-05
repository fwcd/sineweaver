//
//  SynthesizerLFOView.swift
//  Sineweaver
//
//  Created on 25.12.24
//

import SwiftUI

struct SynthesizerLFOView: View {
    @Binding var node: LFONode

    @State private var referenceDate = Date()
    
    var body: some View {
        let size = ComponentDefaults.padSize / 2
        TimelineView(.animation) { context in
            SynthesizerChartView(
                node: node,
                timeInterval: context.date.timeIntervalSince(referenceDate),
                displaySampleRate: 100,
                displayInterval: 0.1
            )
            .frame(width: size, height: size)
        }
    }
}

#Preview {
    @Previewable @State var node = LFONode(frequency: 0.5)
    
    SynthesizerLFOView(node: $node)
}
