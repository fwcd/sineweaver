//
//  WelcomeView.swift
//  Sineweaver
//
//  Created on 25.12.24
//

import SwiftUI

struct WelcomeView: View {
    @EnvironmentObject private var viewModel: TutorialViewModel
    
    var body: some View {
        VStack(spacing: 40) {
            Image("AppIconEmbed")
                .resizable()
                .aspectRatio(1, contentMode: .fit)
                .frame(width: 150)
                .clipShape(RoundedRectangle(cornerRadius: 30))
            VStack(spacing: 20) {
                Text("Sineweaver")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Text("An introduction to synthesizers")
                    .font(.title2)
                Text("Electronic music is everywhere, yet traditional music education often focuses on classical or acoustic compositions. Synthesizers, the instruments at the heart of electronic music, offer virtually limitless possibilities for crafting sounds from scratch. In this playground we will explore some of the fundamental components of a synthesizer and how they can be used for sound design.")
                    .lineLimit(nil)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}
