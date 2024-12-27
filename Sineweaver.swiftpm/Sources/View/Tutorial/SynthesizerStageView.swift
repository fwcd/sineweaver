//
//  SynthesizerStageView.swift
//  Sineweaver
//
//  Created on 25.12.24
//

import SwiftUI

struct SynthesizerStageView: View {
    let stage: SynthesizerStage
    
    @Environment(SynthesizerViewModel.self) private var viewModel
    
    var body: some View {
        SynthesizerView(model: .constant(viewModel.model.lock().wrappedValue))
            .onAppear {
                let model = viewModel.model.lock()
                stage.configure(synthesizer: &model.wrappedValue)
            }
    }
}

#Preview {
    SynthesizerStageView(stage: .basicOscillator)
}
