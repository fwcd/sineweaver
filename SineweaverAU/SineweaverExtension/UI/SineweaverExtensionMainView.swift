//
//  SineweaverExtensionMainView.swift
//  Sineweaver
//
//  Created on 04.03.25
//

import SwiftUI

@MainActor private let synthesizer = SynthesizerViewModel()
@MainActor private let tutorial = TutorialViewModel(synthesizer: synthesizer)

struct SineweaverExtensionMainView: View {
    var parameterTree: ObservableAUParameterGroup
    
    var body: some View {
        // ParameterSlider(param: parameterTree.global.gain)
        SineweaverView()
            .environmentObject(synthesizer)
            .environmentObject(tutorial)
    }
}
