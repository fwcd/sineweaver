//
//  01-BasicOscillatorStageView.swift
//  Sineweaver
//
//  Created on 25.12.24
//

import SwiftUI

struct BasicOscillatorStageView: View, TutorialStageDetails {
    // TODO: Use an actual oscillator
    
    @State private var node: OscillatorNode = .init(frequency: 50, volume: 1)
    
    var title: String? {
        "The Oscillator"
    }
    
    var details: [String] {
        [
            #"At the most fundamental level, a synthesizer produces sounds by sampling a periodic function, commonly a sine wave. The synthesizer presented here is called an "oscillator" and it forms the fundamental building block of almost every form of audio synthesis."#,
            "This oscillator has two parameters: Frequency (or pitch) and volume. Try moving the slider on the right-hand side to play the synth and control the parameters.",
        ]
    }
    
    var body: some View {
        SynthesizerOscillatorView(node: $node)
    }
}

#Preview {
    BasicOscillatorStageView()
}
