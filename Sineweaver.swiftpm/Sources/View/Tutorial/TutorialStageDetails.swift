//
//  TutorialStageDetails.swift
//  Sineweaver
//
//  Created on 25.12.24
//

import SwiftUI

@MainActor
protocol TutorialStageDetails {
    var title: String? { get }
    var details: String? { get }
}

extension TutorialStageDetails {
    var title: String? { nil }
    var details: String? { nil }
}

extension _ConditionalContent: TutorialStageDetails
where TrueContent: TutorialStageDetails,
      FalseContent: TutorialStageDetails {
    var title: String? {
        switch storage {
        case .trueContent(let content): content.title
        case .falseContent(let content): content.title
        }
    }
    
    var details: String? {
        switch storage {
        case .trueContent(let content): content.details
        case .falseContent(let content): content.details
        }
    }
}
