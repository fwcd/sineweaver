//
//  SynthesizerNodeType.swift
//  Sineweaver
//
//  Created on 23.11.24
//

enum SynthesizerNodeType: String, CaseIterable, Hashable {
    case oscillator = "Oscillator"
    case mixer = "Mixer"
    case silence = "Silence"
    case wavExport = "WAV Export"
    case envelope = "Envelope"
    
    var name: String {
        rawValue
    }
}
