//
//  SynthesizerViewModel.swift
//  Sineweaver
//
//  Created on 25.12.24
//

import Foundation
import Observation
import Synchronization

@Observable
final class SynthesizerViewModel: Sendable {
    private let synthesizer = try! Synthesizer()
    
    var startDate: Date {
        synthesizer.startDate
    }
    
    var level: SendableAtomic<Double> {
        synthesizer.level
    }
    
    @MainActor
    var model: SynthesizerModel {
        get { synthesizer.model }
        set { synthesizer.model = newValue }
    }
}
