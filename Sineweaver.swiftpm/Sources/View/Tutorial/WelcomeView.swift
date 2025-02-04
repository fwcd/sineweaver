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
                Text("Electronic music is everywhere, yet traditional music education often focuses on classical or acoustic compositions. This playground aims to explore some of the basic principles of (modular) synthesizers and their virtually limitless possibilities for sound design.")
                    .lineLimit(nil)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .frame(maxWidth: 800)
    }
}
