//
//  SynthesizerStage.swift
//  Sineweaver
//
//  Created on 27.12.24
//

import Foundation

private let oscillatorId = UUID()

enum SynthesizerStage: Hashable, CaseIterable {
    case basicOscillator
    case pianoOscillator
    
    var title: String {
        switch self {
        case .basicOscillator, .pianoOscillator: "The Oscillator"
        }
    }
    
    var details: [String] {
        switch self {
        case .basicOscillator:
            [
                #"At the most fundamental level, a synthesizer produces sounds by sampling a periodic function, commonly a sine wave. The synthesizer presented here is called an "oscillator" and it forms the fundamental building block of almost every form of audio synthesis."#,
                "This oscillator has two parameters: Frequency (or pitch) and volume. Press and drag the slider on the right-hand side to play the synth and control the parameters.",
            ]
        case .pianoOscillator:
            [
                "Setting the pitch directly is a bit inconvenient, so let's add a piano keyboard. Try playing different notes and see how the oscillator changes.",
            ]
        }
    }
    
    func configure(synthesizer: inout SynthesizerModel) {
        switch self {
        case .basicOscillator, .pianoOscillator:
            synthesizer = .init(
                nodes: [oscillatorId: .oscillator(.init(volume: 0.5, prefersPianoView: self == .pianoOscillator))],
                inputEdges: [oscillatorId: []],
                outputNodeId: oscillatorId
            )
        }
    }
}
