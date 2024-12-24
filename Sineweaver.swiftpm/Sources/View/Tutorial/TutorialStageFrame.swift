//
//  TutorialStageFrame.swift
//  Sineweaver
//
//  Created on 25.12.24
//

import SwiftUI

struct TutorialStageFrame<Content>: View where Content: View {
    @ViewBuilder var content: () -> Content
    
    @Environment(TutorialViewModel.self) private var viewModel

    var body: some View {
        VStack(spacing: 20) {
            content()
            HStack {
                Button("Back") {
                    viewModel.stage.back()
                }
                .buttonStyle(BorderedButtonStyle())
                Button("Next") {
                    viewModel.stage.forward()
                }
                .buttonStyle(BorderedProminentButtonStyle())
            }
        }
    }
}
