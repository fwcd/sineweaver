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
private let filterId = UUID()
private let lfoMixerId = UUID()
private let lfoId = UUID()

enum SynthesizerChapter: Hashable, CaseIterable, Comparable {
    case basicOscillator
    case pianoOscillator
    case envelopeIntro
    case envelope
    case lfo
    case filter
    
    var title: String {
        switch self {
        case .basicOscillator, .pianoOscillator, .envelopeIntro: "The Oscillator"
        case .envelope: "The Envelope"
        case .lfo: "The LFO"
        case .filter: "The Filter"
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
        case .envelopeIntro:
            [
                "Most sounds are a bit more complex than a sine wave, however. Hitting a drum or a piano key, for example, produces a relatively loud initial sound (the _attack_) that subsequently falls in volume (the _decay_). In the case of a piano key, the sound is also _sustained_ at a certain volume until the key is _released_. Wouldn't it be nice if the synthesizer could emulate this?",
            ]
        case .envelope:
            [
                "Turns out, most synthesizers do offer four parameters to customize the so-called _envelope_ of a wave: **Attack** (the initial ramp-up in volume), **Decay** (the subsequent fall in volume), **Sustain** (the sustained volume) and **Release** (the final drop to silence). Together these parameters are known under the acronym **ADSR**.",
                "Try dragging the envelope control points (or the knobs below) to customize the ADSR parameters and see how the sound changes when you press a piano key!",
                // TODO: Add presets to avoid overwhelming the user here?
            ]
        case .lfo:
            [
                "Oscillators are not just useful for generating sounds directly, they can also be used to influence other signals, this is known as _modulation_. Usually such oscillators will operate at a much lower frequency than those used to generate sounds, therefore they are commonly referred to as **Low-Frequency Oscillators** (**LFOs**).",
            ]
        // TODO: Introduce frequency/time-domain first?
        case .filter:
            [
                "Filters are another way of processing the audio signal, namely by boosting or attenuating different frequencies. The simplest kind of filter is a **low-pass filter**, which leaves all frequencies below a cutoff frequency untouched (the **passband**) and silences all frequencies above the cutoff (the **stopband**). Swapping passband and stopband gives us a **high-pass filter**, i.e. one that only lets high frequencies pass.",
                "In reality perfect filters (also called _brickwall filters_) with a perfectly sharp cutoff are not achievable, since they would introduce an infinitely long delay. The specifics are not too relevant here, in practice this just means that every filter will have a certain _roll-off_, i.e. the frequencies around the cutoff will still pass the filter, albeit slightly attenuated.",
                "Try tweaking the filter below and see how the sound changes!",
            ]
        }
    }
    
    var hiddenNodeIds: Set<UUID> {
        [activeGateId]
    }
    
    func configure(synthesizer: inout SynthesizerModel) {
        var synth = SynthesizerModel()
        
        synth.outputNodeId = synth.addNode(id: oscillatorId, .oscillator(.init(
            wave: self >= .filter ? .saw : .sine, // TODO: Add explanation
            volume: 0.5,
            prefersPianoView: self >= .pianoOscillator
        )))
        
        if self >= .lfo {
            synth.addNode(id: lfoId, .lfo(.init()))
            
            if self >= .filter {
                synth.addNode(id: filterId, .filter(.init()))
                synth.connect(synth.outputNodeId!, to: filterId)
                synth.connect(lfoId, to: filterId)
                synth.outputNodeId = filterId
            } else {
                synth.addNode(id: lfoMixerId, .mixer(.init(operation: .product)))
                synth.connect(synth.outputNodeId!, to: lfoMixerId)
                synth.connect(lfoId, to: lfoMixerId)
                synth.outputNodeId = lfoMixerId
            }
        }

        if self >= .envelope {
            synth.addNode(id: envelopeId, .envelope(.init()))
            synth.connect(synth.outputNodeId!, to: envelopeId)
            synth.outputNodeId = envelopeId
        } else {
            synth.addNode(id: activeGateId, .activeGate(.init()))
            synth.connect(synth.outputNodeId!, to: activeGateId)
            synth.outputNodeId = activeGateId
        }
        
        synthesizer = synth
    }
}
