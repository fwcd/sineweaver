//
//  SynthesizerStage.swift
//  Sineweaver
//
//  Created on 27.12.24
//

import Foundation

private let oscillatorId = UUID()
private let activeGateId = UUID()
private let envelopeId = UUID()

enum SynthesizerStage: Hashable, CaseIterable, Comparable {
    case basicOscillator
    case pianoOscillator
    case envelope
    
    var title: String {
        switch self {
        case .basicOscillator, .pianoOscillator: "The Oscillator"
        case .envelope: "The Envelope"
        }
    }
    
    var details: [String] {
        switch self {
        case .basicOscillator:
            [
                // TODO: Square waves etc.?
                #"At the most fundamental level, a synthesizer produces sounds by sampling a periodic function, commonly a sine wave. The synthesizer presented here is called an **oscillator** and it forms the fundamental building block of almost every form of audio synthesis."#,
                "This oscillator has two parameters: **Frequency** (or **pitch**) and **volume**. Press and drag the slider on the right-hand side to play the synth and control the parameters.",
            ]
        case .pianoOscillator:
            [
                "Setting the pitch directly is a bit inconvenient, so let's add a piano keyboard. Try playing different notes and see how the oscillator changes.",
            ]
        case .envelope:
            [
                "Most sounds are a bit more complex than a sine wave, however. Hitting a drum or a piano key, for example, produces a relatively loud initial sound (the _attack_) that subsequently falls in volume (the _decay_). In the case of a piano key, the sound is also _sustained_ at a certain volume until the key is _released_. This \"shape\" of a sound is known as the **envelope** and can be customized using the four parameters: **Attack**, **decay**, **sustain** and **release**.",
            ]
        }
    }
    
    var hiddenNodeIds: Set<UUID> {
        self <= .envelope ? [activeGateId] : []
    }
    
    func configure(synthesizer: inout SynthesizerModel) {
        var newSynth = SynthesizerModel()
        
        newSynth.outputNodeId = newSynth.addNode(id: oscillatorId, .oscillator(.init(
            volume: 0.5,
            prefersPianoView: self >= .pianoOscillator
        )))
        
        if self >= .envelope {
            newSynth.outputNodeId = newSynth.addNode(id: envelopeId, .envelope(.init()))
            newSynth.connect(oscillatorId, to: envelopeId)
        } else {
            newSynth.outputNodeId = newSynth.addNode(id: activeGateId, .activeGate(.init()))
            newSynth.connect(oscillatorId, to: activeGateId)
        }
        
        synthesizer = newSynth
    }
}
