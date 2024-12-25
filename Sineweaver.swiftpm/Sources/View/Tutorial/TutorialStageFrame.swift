//
//  TutorialStageFrame.swift
//  Sineweaver
//
//  Created on 25.12.24
//

import SwiftUI

struct TutorialStageFrame<Content>: View where Content: View & TutorialStageDetails {
    @ViewBuilder var content: () -> Content
    
    @Environment(TutorialViewModel.self) private var viewModel

    var body: some View {
        VStack(spacing: 40) {
            let content = self.content()
            if let title = content.title {
                Text(title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
            }
            if let details = content.details {
                Text(details)
                    .font(.title3)
            }
            content
                .frame(maxHeight: 500)
            HStack {
                if !viewModel.stage.isFirst {
                    Button("Back") {
                        viewModel.stage.back()
                    }
                    .buttonStyle(BorderedButtonStyle())
                }
                Button(viewModel.stage.isFirst ? "Get Started" : "Next") {
                    viewModel.stage.forward()
                }
                .buttonStyle(BorderedProminentButtonStyle())
            }
            .animation(.default, value: viewModel.stage)
        }
    }
}
