//
//  SynthesizerChapter.swift
//  Sineweaver
//
//  Created on 27.12.24
//

import Foundation

private let oscillatorId = UUID()
private let activeGateId = UUID()
private let envelopeId = UUID()
private let lfoId = UUID()

enum SynthesizerChapter: Hashable, CaseIterable, Comparable {
    case basicOscillator
    case pianoOscillator
    case envelope
    case lfo
    
    var title: String {
        switch self {
        case .basicOscillator, .pianoOscillator: "The Oscillator"
        case .envelope: "The Envelope"
        case .lfo: "The LFO"
        }
    }
    
    var details: [String] {
        switch self {
        case .basicOscillator:
            [
                // TODO: Square waves etc.? Maybe a generic preset mechanism that we could later use for the envelope too would be appropriate?
                #"At the most fundamental level, a synthesizer produces sounds by sampling a periodic function, commonly a sine wave. The synthesizer presented here is called an **oscillator** and it forms the fundamental building block of almost every form of audio synthesis."#,
                "This oscillator has two parameters: **Frequency** (or **pitch**) and **volume**. Press and drag the slider on the right-hand side to play the synth and control the parameters.",
            ]
        case .pianoOscillator:
            [
                "Setting the pitch directly is a bit inconvenient, so let's add a piano keyboard. Try playing different notes and see how the oscillator changes.",
            ]
        case .envelope:
            [
                "Most sounds are a bit more complex than a sine wave, however. Hitting a drum or a piano key, for example, produces a relatively loud initial sound (the _attack_) that subsequently falls in volume (the _decay_). In the case of a piano key, the sound is also _sustained_ at a certain volume until the key is _released_. This \"shape\" of a sound is known as the **envelope** and can be customized using the four parameters: **Attack**, **decay**, **sustain** and **release** (**ADSR**).",
                "Try dragging the envelope control points (or the knobs below) to customize the ADSR parameters and see how the sound changes when you press a piano key!",
                // TODO: Add presets to avoid overwhelming the user here?
            ]
        case .lfo:
            [
                "Oscillators are not just useful for generating sounds directly, they can also be used to influence other signals, this is known as _modulation_. Usually such oscillators will operate at a much lower frequency than those used to generate sounds, therefore they are commonly referred to as **Low-Frequency Oscillators** (**LFOs**).",
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
        
        if self >= .lfo {
            newSynth.addNode(id: lfoId, .lfo(.init(frequency: 0.5, isPlaying: true)))
            newSynth.connect(lfoId, to: envelopeId)
        }
        
        synthesizer = newSynth
    }
}
