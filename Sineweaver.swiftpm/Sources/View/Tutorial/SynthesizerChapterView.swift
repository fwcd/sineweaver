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
            HStack {
                SynthesizerView(
                    model: $model,
                    hiddenNodeIds: chapter.hiddenNodeIds
                )
                TimelineView(.animation(minimumInterval: 0.1)) { _ in
                    let level = viewModel.synthesizer.level.load(ordering: .relaxed)
                    ComponentBox("Level") {
                        VUMeter(value: level)
                            .padding(.horizontal, 40)
                        Text(String(format: "%.2f dB", 10 * log10(level)))
                            .monospaced()
                            .font(.system(size: 12))
                    }
                }
            }
        }
    }
}

#Preview {
    SynthesizerChapterView(chapter: .basicOscillator)
}
