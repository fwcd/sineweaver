//
//  TutorialView.swift
//  Sineweaver
//
//  Created on 24.12.24
//

import SwiftUI

struct TutorialView: View {
    @State private var stage: TutorialStage = .welcome
    
    var body: some View {
        switch stage {
        case .welcome:
            WelcomeView()
        }
    }
}

#Preview {
    TutorialView()
}
