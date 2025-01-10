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
    @State private var chapterPickerShown = false

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
        .animation(.default, value: viewModel.chapterIndex)
        .animation(.default, value: viewModel.detailIndex)
        .frame(
            maxWidth: viewModel.isFirstChapter ? nil : .infinity,
            maxHeight: viewModel.isFirstChapter ? nil : .infinity
        )
        .safeAreaInset(edge: .bottom) {
            VStack {
                if !viewModel.isFirstChapter && !viewModel.isLastChapter {
                    Button("Chapter \(viewModel.chapterIndex) of \(SynthesizerChapter.allCases.count)") {
                        chapterPickerShown = true
                    }
                }
                HStack {
                    if !viewModel.isFirstChapter {
                        Button {
                            viewModel.back()
                        } label: {
                            Image(systemName: "chevron.left")
                            Text(viewModel.isLastChapter ? "Tutorial" : "Back")
                        }
                        .buttonStyle(.bordered)
                    }
                    if viewModel.isLastChapter {
                        Button {
                            viewModel.goTo(chapterIndex: 0)
                        } label: {
                            Image(systemName: "house")
                            Text("Welcome")
                        }
                        .buttonStyle(.bordered)
                    }
                    if !viewModel.isLastChapter {
                        Button {
                            viewModel.forward()
                        } label: {
                            if viewModel.isFirstChapter {
                                Text("Get Started")
                                    .bigLabel()
                            } else {
                                Text(viewModel.isAlmostCompleted ? "Complete Tutorial" : "Next")
                                Image(systemName: "chevron.right")
                            }
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    if viewModel.isFirstChapter {
                        Button {
                            viewModel.skipTutorial()
                        } label: {
                            Text("Skip Tutorial")
                                .bigLabel()
                        }
                        .buttonStyle(.bordered)
                    }
                }
            }
            .animation(.default, value: viewModel.chapterIndex)
            .animation(.default, value: viewModel.detailIndex)
            .popover(isPresented: $chapterPickerShown) {
                @Bindable var viewModel = viewModel
                VStack(alignment: .leading, spacing: 5) {
                    ForEach(Array(SynthesizerChapter.allCases.enumerated()), id: \.offset) { (i, chapter) in
                        Text("Chapter \(i + 1): \(chapter.title)")
                            .fontWeight(i + 1 == viewModel.chapterIndex ? .bold : nil)
                            .onTapGesture {
                                viewModel.goTo(chapterIndex: i + 1)
                            }
                    }
                }
                .padding()
            }
        }
    }
}

private extension View {
    func bigLabel() -> some View {
        frame(minWidth: 140, minHeight: 40)
    }
}
