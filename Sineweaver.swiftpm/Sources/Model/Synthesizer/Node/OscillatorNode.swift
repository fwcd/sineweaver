//
//  OscillatorNode.swift
//  Sineweaver
//
//  Created on 22.11.24
//

import Foundation

/// A wave generator that generates a signal between -1 and 1.
struct OscillatorNode: SynthesizerNodeProtocol {
    var wave: Wave = .sine
    var frequency: Double = 440
    var volume: Double = 0.75
    var isPlaying = false
    var prefersWavePicker = true
    var prefersPianoView = true
    var pianoBaseOctave: Int = 3

    enum Wave: String, Hashable, Codable, CaseIterable, CustomStringConvertible {
        case sine = "Sine"
        case saw = "Saw"
        case square = "Square"
        case pulse = "Pulse"
        case triangle = "Triangle"
        
        var description: String {
            rawValue
        }
        
        func sample(_ x: Double) -> Double {
            switch self {
            case .sine:
                return sin(2 * .pi * x)
            case .saw:
                return 2 * (x + 0.5).truncatingRemainder(dividingBy: 1) - 1
            case .square:
                return (x + 0.5).truncatingRemainder(dividingBy: 1) < 0.5 ? -1 : 1
            case .pulse:
                return (x + 0.5).truncatingRemainder(dividingBy: 1) < 0.1 ? 1 : -1
            case .triangle:
                let remainder = (x + 0.75).truncatingRemainder(dividingBy: 1)
                return 4 * (remainder < 0.5 ? 1 - remainder : remainder) - 3
            }
        }
    }
    
    struct State {
        var phase: Double = 0
    }
    
    func makeState() -> State {
        State()
    }
    
    func render(inputs: [SynthesizerNodeInput], output: inout [Double], state: inout State, context: SynthesizerContext) -> Bool {
        let controlFrequency = inputs.first
        for i in 0..<output.count {
            output[i] = wave.sample(state.phase) * volume
            let frequency = controlFrequency?.buffer[i] ?? frequency
            state.phase += frequency / context.sampleRate
        }
        return controlFrequency?.isActive ?? isPlaying
    }
}
