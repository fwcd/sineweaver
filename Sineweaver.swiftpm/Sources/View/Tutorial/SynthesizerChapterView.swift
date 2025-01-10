//
//  SynthesizerChapterView.swift
//  Sineweaver
//
//  Created on 25.12.24
//

import SwiftUI
import Synchronization

struct SynthesizerChapterView: View {
    var chapter: SynthesizerChapter? = nil
    
    @EnvironmentObject private var viewModel: SynthesizerViewModel
    
    var body: some View {
        Debouncer(wrappedValue: $viewModel.model) { $model in
            SynthesizerView(
                model: $model,
                startDate: viewModel.startDate,
                hiddenNodeIds: chapter?.hiddenNodeIds ?? [],
                allowsEditing: chapter == nil
            ) {
                LiveLevel(level: viewModel.level)
            }
        }
    }
    
    private struct LiveLevel: View {
        let level: SendableAtomic<Double>
        
        var body: some View {
            TimelineView(.animation(minimumInterval: 0.1)) { context in
                let level = level.wrappedAtomic.load(ordering: .relaxed)
                SynthesizerLevelView(level: level)
            }
        }
    }
}

#Preview {
    SynthesizerChapterView(chapter: .basicOscillator)
}
