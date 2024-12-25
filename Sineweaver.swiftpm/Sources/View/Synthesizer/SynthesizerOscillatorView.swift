//
//  SynthesizerOscillatorView.swift
//  Sineweaver
//
//  Created on 25.12.24
//

import SwiftUI

struct SynthesizerOscillatorView<Node>: View where Node: SynthesizerNodeProtocol {
    let node: Node
    
    var body: some View {
        let displaySampleRate: Double = 2000
        let displayInterval: TimeInterval = 0.2
        ChartView(sampleCount: Int(displaySampleRate * displayInterval)) { output in
            node.render(inputs: [], output: &output, context: .init(
                frame: 0,
                sampleRate: Double(displaySampleRate)
            ))
        }
    }
}

#Preview {
    SynthesizerOscillatorView(node: SineNode(frequency: 440))
}
