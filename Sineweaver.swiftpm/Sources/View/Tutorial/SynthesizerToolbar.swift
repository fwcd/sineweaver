//
//  SynthesizerToolbar.swift
//  Sineweaver
//
//  Created on 10.01.25
//

import SwiftUI
import OSLog

private let log = Logger(subsystem: "Sineweaver", category: "SynthesizerToolbar")

struct SynthesizerToolbar: View {
    @EnvironmentObject private var viewModel: SynthesizerViewModel
    @State private var presetPopoverShown = false
    @State private var helpPopoverShown = false
    @State private var openError: String? = nil
    @State private var openDialogShown = false
    @State private var saveDialogShown = false

    var body: some View {
        Group {
            Button {
                viewModel.model = .init()
            } label: {
                Label("Clear", systemImage: "trash")
            }
            Button {
                viewModel.model = SynthesizerChapter.fullyConfiguredSynthesizer
            } label: {
                Label("Reset", systemImage: "arrow.uturn.backward")
            }
            Button {
                presetPopoverShown = true
            } label: {
                Label("Open Preset", systemImage: "square.dashed")
            }
            .popover(isPresented: $presetPopoverShown) {
                VStack(alignment: .leading, spacing: 5) {
                    let _ = print(SynthesizerPreset.presetsInBundle)
                    ForEach(SynthesizerPreset.presetsInBundle) { preset in
                        Text(preset.name)
                            .onTapGesture {
                                do {
                                    viewModel.model = try preset.read()
                                } catch {
                                    // TODO: Make this a modal
                                    log.error("Could not read preset: \(error)")
                                }
                            }
                    }
                }
                .padding()
            }
            Button {
                openDialogShown = true
            } label: {
                Label("Open", systemImage: "folder")
            }
            .fileImporter(
                isPresented: $openDialogShown,
                allowedContentTypes: SynthesizerModel.readableContentTypes
            ) { result in
                guard case let .success(url) = result,
                      let data = try? Data(contentsOf: url) else { return }
                do {
                    viewModel.model = try SynthesizerModel(data: data)
                } catch {
                    openError = "Could not open model: \(error)"
                }
            }
            .alert(openError ?? "Could not open model", isPresented: $openError.notNil) {
                Button("OK") {}
            }
            Button {
                saveDialogShown = true
            } label: {
                Label("Save", systemImage: "display.and.arrow.down")
            }
            .fileExporter(
                isPresented: $saveDialogShown,
                document: viewModel.model,
                contentType: SynthesizerModel.contentType,
                defaultFilename: "My Synthesizer.json"
            ) { _ in }
            Button {
                helpPopoverShown = true
            } label: {
                Label("Help", systemImage: "questionmark")
            }
            .popover(isPresented: $helpPopoverShown, arrowEdge: .bottom) {
                Text(
                    // TODO: Make sure the UI references (e.g. button names) are accurate before submitting
                    """
                    Sineweaver is a modular synthesizer that lets you arrange different audio-processing components in a graph-like fashion. The tutorial provides a step-by-step introduction to these.
                    
                    To add or remove nodes, hover one of the existing nodes and press one of the "+" buttons or the "x" in the top-right corner, respectively.
                    
                    For inspiration, check out the presets by clicking the "Open Preset" button.
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
