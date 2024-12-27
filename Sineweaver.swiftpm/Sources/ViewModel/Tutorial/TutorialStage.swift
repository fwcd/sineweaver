//
//  TutorialStage.swift
//  Sineweaver
//
//  Created on 25.12.24
//

enum TutorialStage: Hashable, CaseIterable {
    case welcome
    case synthesizer(SynthesizerStage)
    
    static var allCases: [Self] {
        [.welcome] + SynthesizerStage.allCases.map { .synthesizer($0) }
    }
    
    var title: String? {
        switch self {
        case .synthesizer(let stage): stage.title
        default: nil
        }
    }
    
    var details: [String] {
        switch self {
        case .synthesizer(let stage): stage.details
        default: []
        }
    }
}
