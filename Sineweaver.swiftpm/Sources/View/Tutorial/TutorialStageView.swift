//
//  TutorialStageView.swift
//  Sineweaver
//
//  Created on 25.12.24
//

import SwiftUI

struct TutorialStageView: View {
    @Environment(TutorialViewModel.self) private var viewModel
    
    private var stage: TutorialStage {
        viewModel.stage
    }
    
    var body: some View {
        TutorialStageFrame(title: stage.title, details: stage.details) {
            switch viewModel.stage {
            case .welcome:
                WelcomeView()
            case .synthesizer(let stage):
                SynthesizerStageView(stage: stage)
            }
        }
    }
}

#Preview {
    TutorialStageView()
}
