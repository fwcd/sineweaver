//
//  SynthesizerToolbar.swift
//  Sineweaver
//
//  Created on 10.01.25
//

import SwiftUI

struct SynthesizerToolbar: View {
    @EnvironmentObject private var viewModel: SynthesizerViewModel

    var body: some View {
        Group {
            Button {
                viewModel.model = .init()
            } label: {
                Label("Clear Synthesizer", systemImage: "trash")
            }
            Button {
                viewModel.model = SynthesizerChapter.fullyConfiguredSynthesizer
            } label: {
                Label("Reset Synthesizer", systemImage: "arrow.uturn.backward")
            }
        }
        .buttonStyle(.bordered)
    }
}
