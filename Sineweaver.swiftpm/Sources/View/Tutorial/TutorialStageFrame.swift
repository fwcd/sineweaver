//
//  TutorialStageFrame.swift
//  Sineweaver
//
//  Created on 25.12.24
//

import SwiftUI

struct TutorialStageFrame<Content>: View where Content: View {
    var title: String? = nil
    var details: [String] = []
    @ViewBuilder var content: () -> Content
    
    @Environment(TutorialViewModel.self) private var viewModel

    var body: some View {
        VStack(spacing: 40) {
            let content = self.content()
            if let title = title {
                Text(title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
            }
            if !details.isEmpty {
                let rawDetails = details[viewModel.detailIndex]
                Text(AttributedString((try? NSAttributedString(markdown: rawDetails)) ?? NSAttributedString(string: rawDetails)))
                    .font(.title3)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: 800)
            }
            content
                .frame(maxWidth: 800, maxHeight: 300)
            HStack {
                if !viewModel.isFirstStage {
                    Button("Back") {
                        withAnimation {
                            viewModel.back()
                        }
                    }
                    .buttonStyle(BorderedButtonStyle())
                }
                Button{
                    withAnimation {
                        viewModel.forward()
                    }
                } label: {
                    if viewModel.isFirstStage {
                        Text("Get Started")
                            .frame(minWidth: 200, minHeight: 40)
                    } else {
                        Text("Next")
                    }
                }
                .buttonStyle(BorderedProminentButtonStyle())
            }
        }
    }
}
