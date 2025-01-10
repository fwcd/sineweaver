//
//  TutorialChapterView.swift
//  Sineweaver
//
//  Created on 25.12.24
//

import SwiftUI

struct TutorialChapterView: View {
    @EnvironmentObject private var viewModel: TutorialViewModel

    private var chapter: TutorialChapter {
        viewModel.chapter
    }
    
    var body: some View {
        TutorialFrame(title: chapter.title, details: chapter.details) {
            if case .welcome = viewModel.chapter {
                WelcomeView()
            } else {
                SynthesizerChapterView(chapter: viewModel.chapter.synthesizerChapter)
            }
        } toolbar: {
            if viewModel.isLastChapter {
                SynthesizerToolbar()
            }
        }
    }
}

#Preview {
    TutorialChapterView()
}
