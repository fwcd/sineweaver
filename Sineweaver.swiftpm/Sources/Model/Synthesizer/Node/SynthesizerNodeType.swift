//
//  SynthesizerNodeType.swift
//  Sineweaver
//
//  Created on 23.11.24
//

enum SynthesizerNodeType: String, CaseIterable, Hashable {
    case oscillator = "Oscillator"
    case lfo = "LFO"
    case noise = "Noise"
    case filter = "Filter"
    case gain = "Gain"
    case mixer = "Mixer"
    case silence = "Silence"
    case envelope = "Envelope"
    case activeGate = "Active Gate"
    case controller = "Controller"
    
    var name: String {
        rawValue
    }
    
    var isGenerator: Bool {
        self == .oscillator || self == .noise
    }
    
    var isDigitalControl: Bool {
        self == .controller
    }
    
    var isGate: Bool {
        self == .envelope || self == .activeGate
    }
}
