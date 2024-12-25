//
//  TutorialStage.swift
//  Sineweaver
//
//  Created on 25.12.24
//

enum TutorialStage: Int, Hashable, CaseIterable {
    case welcome = 0
    case basicOscillator
    
    var isFirst: Bool {
        rawValue == 0
    }
    
    var previous: Self {
        Self.allCases[(rawValue - 1 + Self.allCases.count) % Self.allCases.count]
    }
    
    var next: Self {
        Self.allCases[(rawValue + 1) % Self.allCases.count]
    }
    
    mutating func back() {
        self = previous
    }
    
    mutating func forward() {
        self = next
    }
}
