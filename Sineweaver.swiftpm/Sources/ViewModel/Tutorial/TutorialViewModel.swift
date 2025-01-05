//
//  TutorialViewModel.swift
//  Sineweaver
//
//  Created on 25.12.24
//

import Observation

@Observable
@MainActor
final class TutorialViewModel: Sendable {
    private let synthesizer: SynthesizerViewModel
    
    var chapterIndex: Int {
        willSet {
            TutorialChapter.allCases[newValue].configure(synthesizer: &synthesizer.model)
        }
    }
    
    var detailIndex: Int
    
    var chapter: TutorialChapter {
        .allCases[chapterIndex]
    }
    
    var isFirstChapter: Bool {
        chapterIndex == 0
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
}
