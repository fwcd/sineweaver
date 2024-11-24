//
//  SynthesizerNodeType.swift
//  Fourier Synth
//
//  Created on 23.11.24
//

enum SynthesizerNodeType: String, CaseIterable, Hashable {
    case sine = "Sine"
    case mixer = "Mixer"
    case silence = "Silence"
    
    var name: String {
        rawValue
    }
}
