//
//  TutorialFrame.swift
//  Sineweaver
//
//  Created on 25.12.24
//

import SwiftUI

struct TutorialFrame<Content>: View where Content: View {
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
                .frame(maxWidth: 800)
                .padding(.bottom, viewModel.isFirstChapter ? 30 : 0)
        }
        .frame(
            maxWidth: viewModel.isFirstChapter ? nil : .infinity,
            maxHeight: viewModel.isFirstChapter ? nil : .infinity
        )
        .safeAreaInset(edge: .bottom) {
            VStack {
                if !viewModel.isFirstChapter {
                    Text("Chapter \(viewModel.chapterIndex) of \(TutorialChapter.allCases.count - 1)")
                    .opacity(0.5)
                }
                HStack {
                    if !viewModel.isFirstChapter {
                        Button {
                            withAnimation {
                                viewModel.back()
                            }
                        } label: {
                            Image(systemName: "chevron.left")
                            Text("Back")
                        }
                        .buttonStyle(BorderedButtonStyle())
                    }
                    Button{
                        withAnimation {
                            viewModel.forward()
                        }
                    } label: {
                        if viewModel.isFirstChapter {
                            Text("Get Started")
                                .frame(minWidth: 200, minHeight: 40)
                        } else {
                            Text("Next")
                            Image(systemName: "chevron.right")
                        }
                    }
                    .buttonStyle(BorderedProminentButtonStyle())
                }
            }
        }
    }
}
