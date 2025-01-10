//
//  TutorialView.swift
//  Sineweaver
//
//  Created on 24.12.24
//

import SwiftUI

struct TutorialView: View {
    var body: some View {
        TutorialChapterView()
            .padding()
    }
}

#Preview {
    let synthesizer = SynthesizerViewModel()
    let tutorial = TutorialViewModel(synthesizer: synthesizer)
    TutorialView()
        .environmentObject(synthesizer)
        .environmentObject(tutorial)
}
