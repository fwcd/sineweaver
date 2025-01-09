//
//  SynthesizerChapterView.swift
//  Sineweaver
//
//  Created on 25.12.24
//

import SwiftUI

struct SynthesizerChapterView: View {
    var chapter: SynthesizerChapter? = nil
    
    @Environment(SynthesizerViewModel.self) private var viewModel
    
    var body: some View {
        @Bindable var viewModel = viewModel
        
        Debouncer(wrappedValue: $viewModel.model) { $model in
            SynthesizerView(
                model: $model,
                startDate: viewModel.synthesizer.startDate,
                hiddenNodeIds: chapter?.hiddenNodeIds ?? [],
                allowsEditing: chapter == nil
            ) {
                LiveLevel(synthesizer: viewModel.synthesizer)
            }
        }
    }
    
    private struct LiveLevel: View {
        let synthesizer: Synthesizer
        
        var body: some View {
            TimelineView(.animation(minimumInterval: 0.1)) { context in
                let level = synthesizer.level.load(ordering: .relaxed)
                SynthesizerLevelView(level: level)
            }
        }
    }
}

#Preview {
    SynthesizerChapterView(chapter: .basicOscillator)
}
