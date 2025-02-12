//
//  TutorialViewModel.swift
//  Sineweaver
//
//  Created on 25.12.24
//

import Combine

@MainActor
final class TutorialViewModel: Sendable, ObservableObject {
    private let synthesizer: SynthesizerViewModel
    
    @Published private(set) var chapterIndex: Int {
        willSet {
            TutorialChapter.allCases[newValue].configure(synthesizer: &synthesizer.model)
        }
    }
    
    @Published private(set) var detailIndex: Int
    
    @Published var hasViewediPhoneHint = false
    
    var chapter: TutorialChapter {
        .allCases[chapterIndex]
    }
    
    var isFirstChapter: Bool {
        chapterIndex == 0
    }
    
    var isAlmostCompleted: Bool {
        chapterIndex == TutorialChapter.allCases.count - 2 && detailIndex == chapter.details.count - 1
    }
    
    var isLastChapter: Bool {
        chapterIndex == TutorialChapter.allCases.count - 1
    }

    init(synthesizer: SynthesizerViewModel, chapterIndex: Int = 0, detailIndex: Int = 0) {
        self.synthesizer = synthesizer
        self.chapterIndex = chapterIndex
        self.detailIndex = detailIndex
    }
    
    func back() {
        if detailIndex > 0 {
            detailIndex -= 1
        } else {
            chapterIndex = (chapterIndex - 1 + TutorialChapter.allCases.count) % TutorialChapter.allCases.count
            detailIndex = chapter.details.count - 1
        }
    }
    
    func forward() {
        if detailIndex < chapter.details.count - 1 {
            detailIndex += 1
        } else {
            chapterIndex = (chapterIndex + 1) % TutorialChapter.allCases.count
            detailIndex = 0
        }
    }
    
    func goTo(chapterIndex: Int) {
        self.chapterIndex = chapterIndex
        detailIndex = 0
    }
    
    func skipTutorial() {
        goTo(chapterIndex: TutorialChapter.allCases.count - 1)
    }
}
