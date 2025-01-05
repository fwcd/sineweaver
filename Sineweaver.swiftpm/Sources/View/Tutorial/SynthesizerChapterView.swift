//
//  SynthesizerChapterView.swift
//  Sineweaver
//
//  Created on 25.12.24
//

import SwiftUI

struct SynthesizerChapterView: View {
    let chapter: SynthesizerChapter
    
    @Environment(SynthesizerViewModel.self) private var viewModel
    
    var body: some View {
        @Bindable var viewModel = viewModel
        
        Debouncer(wrappedValue: $viewModel.model) { $model in
            SynthesizerView(
                model: $model,
                hiddenNodeIds: chapter.hiddenNodeIds
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
