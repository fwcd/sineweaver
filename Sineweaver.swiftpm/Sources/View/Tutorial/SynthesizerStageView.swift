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
        @Bindable var viewModel = viewModel
        
        Debouncer(wrappedValue: $viewModel.model) { $model in
            SynthesizerView(model: $model)
        }
    }
}

#Preview {
    SynthesizerStageView(stage: .basicOscillator)
}
