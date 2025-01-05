//
//  EnvelopeNode.swift
//  Sineweaver
//
//  Created on 05.01.25
//

import Foundation

/// A node that applies an ADSR envelope to a signal.
struct EnvelopeNode: SynthesizerNodeProtocol {
    var attackMs: Double = 10
    var decayMs: Double = 100
    var sustain: Double = 0.3
    var releaseMs: Double = 50
    
    struct State {
        var isActive = false
        var phaseFrame: Int = 0
    }
    
    func makeState() -> State {
        State()
    }
    
    func render(inputs: [[Double]], output: inout [Double], state: inout State, context: SynthesizerContext) {
        guard let input = inputs.first else { return }
        
        let isActive = input.contains(where: { $0 != 0 })
        if isActive != state.isActive {
            state.isActive = isActive
            state.phaseFrame = 0
        }
        
        for i in 0..<output.count {
            output[i] = input[i] * amplitude(at: state.phaseFrame, isActive: state.isActive, context: context)
            state.phaseFrame += 1
        }
    }
    
    func amplitude(at phaseFrame: Int, isActive: Bool, context: SynthesizerContext) -> Double {
        let samplesPerMs = context.sampleRate / 1000
        var frame = phaseFrame
        
        if isActive {
            let attackFrames = Int(attackMs * samplesPerMs)
            let decayFrames = Int(decayMs * samplesPerMs)
            
            if frame < attackFrames {
                let attackPhase = Double(frame) / Double(attackFrames)
                return attackPhase
            }
            
            frame -= attackFrames
            if frame < decayFrames {
                let decayPhase = Double(frame) / Double(decayFrames)
                return (1 - decayPhase) + sustain * decayPhase
            }
            
            return sustain
        } else {
            let releaseFrames = Int(releaseMs * samplesPerMs)
            
            if frame < releaseFrames {
                let releasePhase = Double(frame) / Double(releaseFrames)
                return sustain * (1 - releasePhase)
            }
            
            return 0
        }
    }
}
