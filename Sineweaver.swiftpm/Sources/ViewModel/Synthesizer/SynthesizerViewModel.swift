//
//  SynthesizerViewModel.swift
//  Sineweaver
//
//  Created on 25.12.24
//

import Foundation
import Combine
import Synchronization

final class SynthesizerViewModel: ObservableObject, Sendable {
    #if SINEWEAVER_AU
    let synthesizer = try! Synthesizer()
    #else
    private let synthesizer = try! Synthesizer()
    #endif
    
    var startDate: Date {
        synthesizer.startDate
    }
    
    var level: SendableAtomic<Double> {
        synthesizer.level
    }
    
    @MainActor
    var model: SynthesizerModel {
        get { synthesizer.model }
        set {
            synthesizer.model = newValue
            objectWillChange.send()
        }
    }
    
    @MainActor
    var hasViewedTips = false
}
