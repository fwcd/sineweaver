//
//  OscillatorNode.swift
//  Sineweaver
//
//  Created on 22.11.24
//

import Foundation

/// A wave generator.
struct OscillatorNode: SynthesizerNodeProtocol {
    var wave: Wave = .sine
    var frequency: Double = 440
    var volume: Double = 1
    var isPlaying = false
    var prefersPianoView = false

    enum Wave: String, Hashable, Codable, CaseIterable {
        case sine = "Sine"
        case saw = "Saw"
        case square = "Square"
        
        func sample(_ x: Double) -> Double {
            switch self {
            case .sine: sin(2 * .pi * x)
            case .saw: 1 - x.truncatingRemainder(dividingBy: 1)
            case .square: x.truncatingRemainder(dividingBy: 1) < 0.5 ? 0 : 1
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
