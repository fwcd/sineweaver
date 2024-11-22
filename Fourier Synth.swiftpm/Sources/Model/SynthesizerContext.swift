//
//  SynthesizerContext.swift
//  Fourier Synth
//
//  Created on 22.11.24
//

struct SynthesizerContext: Hashable, Codable, Sendable {
    var frame: Double = 0
    var sampleRate: Double = 0
}
