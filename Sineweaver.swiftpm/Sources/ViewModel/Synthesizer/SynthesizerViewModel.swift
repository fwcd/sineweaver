//
//  SynthesizerViewModel.swift
//  Sineweaver
//
//  Created on 25.12.24
//

import Observation

@Observable
final class SynthesizerViewModel: Sendable {
    let synthesizer = try! Synthesizer()
    
    var model: Mutex<SynthesizerModel> {
        synthesizer.model
    }
}
