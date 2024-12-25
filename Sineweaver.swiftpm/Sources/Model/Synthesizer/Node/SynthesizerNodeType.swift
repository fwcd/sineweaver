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
    
    var name: String {
        rawValue
    }
}
