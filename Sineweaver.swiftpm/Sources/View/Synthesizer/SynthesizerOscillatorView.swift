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
        let displaySampleRate: Double = 44_100
        let displayInterval: TimeInterval = 0.05
        let displayAmplitude: Double = 1.05
        ChartView(yRange: -displayAmplitude..<displayAmplitude, sampleCount: Int(displaySampleRate * displayInterval)) { output in
            node.render(inputs: [], output: &output, context: .init(
                frame: 0,
                sampleRate: Double(displaySampleRate)
            ))
        }
    }
}

#Preview {
    VStack(spacing: 50) {
        ForEach(OscillatorNode.Wave.allCases, id: \.self) { wave in
            SynthesizerOscillatorView(node: OscillatorNode(wave: wave, frequency: 40))
                .frame(maxHeight: 100)
        }
    }
}
