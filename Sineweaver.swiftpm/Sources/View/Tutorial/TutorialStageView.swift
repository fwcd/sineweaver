//
//  TutorialStageView.swift
//  Sineweaver
//
//  Created on 25.12.24
//

import SwiftUI

struct TutorialStageView: View {
    @Environment(TutorialViewModel.self) private var viewModel
    
    var body: some View {
        switch viewModel.stage {
        case .welcome:
            WelcomeView()
        case .basicSine:
            BasicSineStageView()
        }
    }
}

#Preview {
    TutorialStageView()
}
