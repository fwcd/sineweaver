//
//  TutorialViewModel.swift
//  Sineweaver
//
//  Created on 25.12.24
//

import Observation

@Observable
@MainActor
final class TutorialViewModel: Sendable {
    private let synthesizer: SynthesizerViewModel
    
    var stageIndex: Int {
        willSet {
            TutorialStage.allCases[newValue].configure(synthesizer: &synthesizer.model)
        }
    }
    
    var detailIndex: Int
    
    var stage: TutorialStage {
        .allCases[stageIndex]
    }
    
    var isFirstStage: Bool {
        stageIndex == 0
    }
    
    init(synthesizer: SynthesizerViewModel, stageIndex: Int = 0, detailIndex: Int = 0) {
        self.synthesizer = synthesizer
        self.stageIndex = stageIndex
        self.detailIndex = detailIndex
    }
    
    func back() {
        if detailIndex > 0 {
            detailIndex -= 1
        } else {
            stageIndex = (stageIndex - 1 + TutorialStage.allCases.count) % TutorialStage.allCases.count
        }
    }
    
    func forward() {
        if detailIndex < stage.details.count - 1 {
            detailIndex += 1
        } else {
            stageIndex = (stageIndex + 1) % TutorialStage.allCases.count
            detailIndex = 0
        }
    }
}
