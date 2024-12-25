//
//  01-BasicOscillatorStageView.swift
//  Sineweaver
//
//  Created on 25.12.24
//

import SwiftUI

struct BasicOscillatorStageView: View, TutorialStageDetails {
    // TODO: Use an actual oscillator
    
    @State private var frequency: Double = 50
    @State private var volume: Double = 1
    
    var title: String? {
        "The Oscillator"
    }
    
    var details: String? {
        """
        At the most fundamental level, a synthesizer produces sounds by sampling a periodic function, commonly a sine wave. Such a synthesizer is called an "oscillator" and it forms the fundamental building block of almost every form of audio synthesis.
        """
    }
    
    var body: some View {
        let group = Group {
            SynthesizerOscillatorView(node: OscillatorNode(
                frequency: frequency,
                volume: volume
            ))
            .frame(minWidth: 300)
            Slider2D(
                x: $frequency.logarithmic,
                in: log(20)...log(20000),
                label: "Frequency",
                y: $volume,
                in: 0...2,
                label: "Volume"
            )
        }
        ViewThatFits {
            HStack {
                group
            }
            VStack {
                group
            }
        }
    }
}

#Preview {
    BasicOscillatorStageView()
}
