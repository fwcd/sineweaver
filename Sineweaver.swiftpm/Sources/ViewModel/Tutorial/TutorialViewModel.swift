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
    var stageIndex: Int = 0
    var detailIndex: Int = 0
    
    var stage: TutorialStage {
        .allCases[stageIndex]
    }
    
    var isFirstStage: Bool {
        stageIndex == 0
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
