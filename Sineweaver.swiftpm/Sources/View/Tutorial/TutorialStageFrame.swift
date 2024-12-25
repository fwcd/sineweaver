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
            if !content.details.isEmpty {
                Text(content.details[viewModel.detailIndex])
                    .font(.title3)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: 800)
            }
            content
                .frame(maxWidth: 800, maxHeight: 300)
            HStack {
                if !viewModel.stage.isFirst {
                    Button("Back") {
                        withAnimation {
                            if viewModel.detailIndex > 0 {
                                viewModel.detailIndex -= 1
                            } else {
                                viewModel.stage.back()
                            }
                        }
                    }
                    .buttonStyle(BorderedButtonStyle())
                }
                Button(viewModel.stage.isFirst ? "Get Started" : "Next") {
                    withAnimation {
                        if viewModel.detailIndex < content.details.count - 1 {
                            viewModel.detailIndex += 1
                        } else {
                            viewModel.stage.forward()
                            viewModel.detailIndex = 0
                        }
                    }
                }
                .buttonStyle(BorderedProminentButtonStyle())
            }
        }
    }
}
