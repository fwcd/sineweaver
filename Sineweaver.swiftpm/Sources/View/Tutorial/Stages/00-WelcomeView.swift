//
//  WelcomeView.swift
//  Sineweaver
//
//  Created on 25.12.24
//

import SwiftUI

struct WelcomeView: View {
    @Environment(TutorialViewModel.self) private var viewModel
    
    var body: some View {
        TutorialStageFrame {
            VStack(spacing: 40) {
                Image("AppIconEmbed")
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                    .frame(width: 150)
                    .clipShape(RoundedRectangle(cornerRadius: 30))
                VStack(spacing: 10) {
                    Text("Welcome to Sineweaver!")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Text("An interactive introduction to synthesizers")
                        .font(.title3)
                }
            }
        }
    }
}
