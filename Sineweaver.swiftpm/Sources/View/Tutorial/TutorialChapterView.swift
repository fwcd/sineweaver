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
            switch viewModel.chapter {
            case .welcome:
                WelcomeView()
            case .synthesizer(let chapter):
                SynthesizerChapterView(chapter: chapter)
            }
        }
    }
}

#Preview {
    TutorialChapterView()
}
