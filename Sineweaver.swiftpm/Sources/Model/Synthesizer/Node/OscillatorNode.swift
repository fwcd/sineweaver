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

    enum Wave: String, Hashable, Codable, CaseIterable, CustomStringConvertible {
        case sine = "Sine"
        case saw = "Saw"
        case square = "Square"
        
        var description: String {
            rawValue
        }
        
        func sample(_ x: Double) -> Double {
            switch self {
            case .sine: sin(2 * .pi * x)
            case .saw: 1 - 2 * x.truncatingRemainder(dividingBy: 1)
            case .square: x.truncatingRemainder(dividingBy: 1) < 0.5 ? -1 : 1
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
        for i in 0..<output.count {
            output[i] = wave.sample(state.phase) * volume
            state.phase += frequency / context.sampleRate
        }
        return isPlaying
    }
}
