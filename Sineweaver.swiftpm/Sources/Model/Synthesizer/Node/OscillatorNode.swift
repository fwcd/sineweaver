//
//  OscillatorNode.swift
//  Sineweaver
//
//  Created on 22.11.24
//

import Foundation

private let semitoneRatio: Double = pow(2, 1.0 / 12)

/// A wave generator that generates a signal between -1 and 1.
struct OscillatorNode: SynthesizerNodeProtocol {
    var wave: Wave = .sine
    var frequency: Double = 440
    var volume: Double = 0.75
    var unison: Int = 1
    var detune: Double = 0
    var isPlaying = false
    var prefersWavePicker = true
    var prefersUnisonDetuneControls = true
    var prefersPianoView = true
    var pianoBaseOctave: Int = 3
    
    enum Wave: String, Hashable, Codable, CaseIterable, CustomStringConvertible {
        case sine = "Sine"
        case triangle = "Triangle"
        case saw = "Saw"
        case square = "Square"
        case pulse = "Pulse"
        
        var description: String {
            rawValue
        }
        
        func sample(_ x: Double) -> Double {
            switch self {
            case .sine:
                return sin(2 * .pi * x)
            case .triangle:
                let remainder = (x + 0.75).truncatingRemainder(dividingBy: 1)
                return 4 * (remainder < 0.5 ? 1 - remainder : remainder) - 3
            case .saw:
                return 2 * (x + 0.5).truncatingRemainder(dividingBy: 1) - 1
            case .square:
                return (x + 0.5).truncatingRemainder(dividingBy: 1) < 0.5 ? -1 : 1
            case .pulse:
                return (x + 0.5).truncatingRemainder(dividingBy: 1) < 0.25 ? 1 : -1
            }
        }
    }
    
    struct State {
        var phases: [Double] = [0]
        
        mutating func expandOrShrink(to unison: Int) {
            while phases.count < unison {
                phases.append(phases.last ?? 0)
            }
            
            if phases.count > unison {
                phases.removeLast(phases.count - unison)
            }
        }
    }
    
    func makeState() -> State {
        State()
    }
    
    func render(inputs: [SynthesizerNodeInput], output: inout [Double], state: inout State, context: SynthesizerContext) -> Bool {
        state.expandOrShrink(to: unison)
        
        let controlFrequency = inputs.first
        for i in 0..<output.count {
            let frequency = controlFrequency?.buffer[i] ?? frequency
            output[i] = sampleAll(frequency: frequency, state: &state, context: context) * volume
        }
        return controlFrequency?.isActive ?? isPlaying
    }
    
    private func sampleAll(frequency baseFrequency: Double, state: inout State, context: SynthesizerContext) -> Double {
        assert(unison == state.phases.count)
        assert(unison >= 0)

        guard unison > 1 else {
            let sample = sampleOne(at: state.phases[0])
            state.phases[0] += baseFrequency / context.sampleRate
            return sample
        }
        
        // Frequencies (in logarithmic space):
        //
        //     | <--------- | ---------> |
        // frequency  baseFrequency  frequency
        // / detune                  * detune
        //
        // With detune being a fraction (i.e. between 0 and 1) of a semitone.
        
        let detuneRatio = pow(semitoneRatio, detune)
        let detuneStepRatio = pow(semitoneRatio, 2 * detune / Double(unison))
        var frequency = baseFrequency / detuneRatio
        var sample: Double = 0

        for i in 0..<unison {
            sample += sampleOne(at: state.phases[i])
            frequency *= detuneStepRatio
            state.phases[i] += frequency / context.sampleRate
        }
        
        return sample / Double(unison)
    }
    
    private func sampleOne(at phase: Double) -> Double {
        wave.sample(phase)
    }
}
