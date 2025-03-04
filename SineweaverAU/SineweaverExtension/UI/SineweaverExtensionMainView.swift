//
//  SineweaverExtensionMainView.swift
//  Sineweaver
//
//  Created on 04.03.25
//

import SwiftUI

@MainActor private let synthesizer = {
    let synthesizer = SynthesizerViewModel()
    // The default preset is the last chapter in the tutorial (i.e. an oscillator with unison/detune + an envelope)
    SynthesizerChapter.allCases.last?.configure(synthesizer: &synthesizer.model)
    return synthesizer
}()

struct SineweaverExtensionMainView: View {
    var parameterTree: ObservableAUParameterGroup
    
    var body: some View {
        SynthesizerChapterView(chapter: nil)
            .environmentObject(synthesizer)
    }
}
