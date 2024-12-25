//
//  SynthesizerLFOView.swift
//  Sineweaver
//
//  Created on 25.12.24
//

import SwiftUI

struct SynthesizerLFOView<Node>: View where Node: SynthesizerNodeProtocol {
    let node: Node
    
    @State private var referenceDate = Date()
    
    var body: some View {
        let displaySampleRate: Double = 2000
        let displayInterval: TimeInterval = 1
        let animationSpeed: Double = 1 // in relation to the original speed
        TimelineView(.animation) { context in
            ChartView(yRange: -1..<1, sampleCount: Int(displaySampleRate * displayInterval)) { output in
                node.render(inputs: [], output: &output, context: .init(
                    frame: Int(context.date.timeIntervalSince(referenceDate) * displaySampleRate * animationSpeed),
                    sampleRate: Double(displaySampleRate)
                ))
            }
        }
    }
}

#Preview {
    SynthesizerLFOView(node: SineNode(frequency: 0.5))
}
