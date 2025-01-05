//
//  SynthesizerNodeType.swift
//  Sineweaver
//
//  Created on 23.11.24
//

enum SynthesizerNodeType: String, CaseIterable, Hashable {
    case oscillator = "Oscillator"
    case lfo = "LFO"
    case mixer = "Mixer"
    case silence = "Silence"
    case wavExport = "WAV Export"
    case envelope = "Envelope"
    case activeGate = "Active Gate"
    
    var name: String {
        rawValue
    }
}
