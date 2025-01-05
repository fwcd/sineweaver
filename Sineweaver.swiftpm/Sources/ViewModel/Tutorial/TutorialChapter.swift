//
//  TutorialChapter.swift
//  Sineweaver
//
//  Created on 25.12.24
//

enum TutorialChapter: Hashable, CaseIterable {
    case welcome
    case synthesizer(SynthesizerChapter)
    
    static var allCases: [Self] {
        [.welcome] + SynthesizerChapter.allCases.map { .synthesizer($0) }
    }
    
    var title: String? {
        switch self {
        case .synthesizer(let chapter): chapter.title
        default: nil
        }
    }
    
    var details: [String] {
        switch self {
        case .synthesizer(let chapter): chapter.details
        default: []
        }
    }
    
    func configure(synthesizer: inout SynthesizerModel) {
        switch self {
        case .welcome: synthesizer = .init()
        case .synthesizer(let chapter): chapter.configure(synthesizer: &synthesizer)
        }
    }
}
