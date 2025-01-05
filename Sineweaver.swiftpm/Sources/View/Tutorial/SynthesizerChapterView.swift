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
            SynthesizerView(model: $model, hiddenNodeIds: chapter.hiddenNodeIds)
        }
    }
}

#Preview {
    SynthesizerChapterView(chapter: .basicOscillator)
}
