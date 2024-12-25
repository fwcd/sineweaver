//
//  SynthesizerOscillatorView.swift
//  Sineweaver
//
//  Created on 25.12.24
//

import SwiftUI

struct SynthesizerOscillatorView<Node>: View where Node: SynthesizerNodeProtocol {
    let node: Node
    
    @State private var referenceDate = Date()
    
    var body: some View {
        let displaySampleRate: Double = 2000
        let displayInterval: TimeInterval = 0.2
        let animationSpeed: Double = 0.05 // in relation to the original speed
        TimelineView(.animation) { context in
            ChartView(sampleCount: Int(displaySampleRate * displayInterval)) { output in
                node.render(inputs: [], output: &output, context: .init(
                    frame: Int(context.date.timeIntervalSince(referenceDate) * displaySampleRate * animationSpeed),
                    sampleRate: Double(displaySampleRate)
                ))
            }
        }
    }
}

#Preview {
    SynthesizerOscillatorView(node: SineNode(frequency: 440))
}
