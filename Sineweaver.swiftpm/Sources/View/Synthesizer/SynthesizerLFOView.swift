//
//  SynthesizerLFOView.swift
//  Sineweaver
//
//  Created on 25.12.24
//

import SwiftUI

struct SynthesizerLFOView: View {
    @Binding var node: OscillatorNode

    @State private var referenceDate = Date()
    
    var body: some View {
        let size = ComponentDefaults.padSize / 2
        TimelineView(.animation) { context in
            let _ = print(context.date)
            SynthesizerChartView(node: node, timeInterval: context.date.timeIntervalSince(referenceDate))
                .frame(width: size, height: size)
        }
    }
}

#Preview {
    @Previewable @State var node = OscillatorNode(frequency: 0.5)
    
    SynthesizerLFOView(node: $node)
}
