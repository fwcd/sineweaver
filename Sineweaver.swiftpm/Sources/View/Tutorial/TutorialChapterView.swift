//
//  TutorialChapterView.swift
//  Sineweaver
//
//  Created on 25.12.24
//

import SwiftUI

struct TutorialChapterView: View {
    @Environment(TutorialViewModel.self) private var viewModel
    
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
        }
    }
}

#Preview {
    TutorialChapterView()
}
