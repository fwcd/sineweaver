//
//  SynthesizerToolbar.swift
//  Sineweaver
//
//  Created on 10.01.25
//

import SwiftUI

struct SynthesizerToolbar: View {
    @EnvironmentObject private var viewModel: SynthesizerViewModel
    @State private var helpPopoverShown = false

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
            Button {
                helpPopoverShown = true
            } label: {
                Label("Help", systemImage: "questionmark")
            }
            .popover(isPresented: $helpPopoverShown, arrowEdge: .bottom) {
                Text(
                    """
                    Sineweaver is a modular synthesizer that lets you arrange different audio-processing components in a graph-like fashion. The tutorial provides a step-by-step introduction to these.
                    
                    To add or remove nodes, hover one of the existing nodes and press one of the "+" buttons or the "x" in the top-right corner, respectively.
                    """
                )
                .lineLimit(nil)
                .multilineTextAlignment(.leading)
                .frame(width: 300, height: 400)
                .padding()
            }
        }
        .buttonStyle(.bordered)
    }
}
