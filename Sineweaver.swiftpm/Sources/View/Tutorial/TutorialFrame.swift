//
//  TutorialFrame.swift
//  Sineweaver
//
//  Created on 25.12.24
//

import SwiftUI

struct TutorialFrame<Content, Toolbar>: View where Content: View, Toolbar: View {
    var title: String? = nil
    var details: [String] = []
    @ViewBuilder var content: () -> Content
    @ViewBuilder var toolbar: () -> Toolbar

    @EnvironmentObject private var viewModel: TutorialViewModel
    @State private var chapterPickerShown = false
    @State private var iPhoneHintShown = false
    @State private var iPhoneHintAction: (() -> Void)? = nil

    var body: some View {
        Group {
            if viewModel.isFirstChapter {
                content()
                    .padding()
            } else {
                ScrollView([.horizontal, .vertical]) {
                    content()
                        .padding()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
        }
        .safeAreaInset(edge: .top) {
            Group {
                if !viewModel.isFirstChapter && !viewModel.isLastChapter {
                    VStack(spacing: 40) {
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
                    }
                    .padding()
                }
            }
        }
        .safeAreaInset(edge: .bottom) {
            VStack {
                if !viewModel.isFirstChapter && !viewModel.isLastChapter {
                    Button("Chapter \(viewModel.chapterIndex) of \(SynthesizerChapter.allCases.count)") {
                        chapterPickerShown = true
                    }
                }
                ViewThatFits {
                    HStack {
                        navigation
                        Group(subviews: toolbar()) { subviews in
                            if !subviews.isEmpty {
                                Divider()
                                    .frame(height: 30)
                                    .fixedSize()
                                subviews
                            }
                        }
                    }
                    HStack {
                        toolbar()
                    }
                    HStack {
                        toolbar()
                            .labelStyle(.iconOnly)
                    }
                }
            }
            .padding()
            .popover(isPresented: $chapterPickerShown) {
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
        .animation(.default, value: viewModel.chapterIndex)
        .animation(.default, value: viewModel.detailIndex)
        .alert("Sineweaver works best on a larger display like an iPad or a Mac. On an iPhone display content may be cut off. (Note that synthesizer views can be scrolled!)", isPresented: $iPhoneHintShown) {
            Button("Continue anyway") {
                iPhoneHintAction?()
                
                iPhoneHintShown = false
                iPhoneHintAction = nil
            }
            Button("Cancel", role: .cancel) {
                iPhoneHintShown = false
                iPhoneHintAction = nil
            }
        }
    }
    
    @ViewBuilder
    private var navigation: some View {
        Group {
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
                    withiPhoneHint {
                        viewModel.forward()
                    }
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
                    withiPhoneHint {
                        viewModel.skipTutorial()
                    }
                } label: {
                    Text("Skip Tutorial")
                        .bigLabel()
                }
                .buttonStyle(.bordered)
            }
        }
    }
    
    private func withiPhoneHint(action: @escaping () -> Void) {
        if !viewModel.hasViewediPhoneHint {
            viewModel.hasViewediPhoneHint = true
            if UIDevice.current.userInterfaceIdiom == .phone {
                iPhoneHintShown = true
                iPhoneHintAction = action
                return
            }
        }
        action()
    }
}

private extension View {
    func bigLabel() -> some View {
        frame(minWidth: 140, minHeight: 40)
    }
}
