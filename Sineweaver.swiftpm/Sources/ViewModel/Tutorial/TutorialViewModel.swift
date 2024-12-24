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
    var stage: TutorialStage = .welcome
}
