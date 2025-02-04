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
    @State private var tipShown = false

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
            .alignmentGuide(.top) {
                $0[.top] - 100
            }
            .overlay(alignment: .top) {
                Group {
                    if tipShown {
                        Tip("Check out the presets for some examples")
                            .lineLimit(nil)
                            .multilineTextAlignment(.center)
                            .frame(width: 200)
                            .fixedSize()
                    }
                }
                .animation(.default, value: tipShown)
            }
            .task {
                if !viewModel.hasViewedTips {
                    viewModel.hasViewedTips = true
                    tipShown = true
                    try? await Task.sleep(for: .seconds(10))
                    tipShown = false
                }
            }
            .onChange(of: presetPopoverShown) {
                if presetPopoverShown {
                    tipShown = false
                }
            }
            .popover(isPresented: $presetPopoverShown) {
                HStack(alignment: .top) {
                    let groupedPresets: [String: [SynthesizerPreset]] = Dictionary(
                        grouping: SynthesizerPreset.presetsInBundle,
                        by: \.category
                    )
                    let sortedGroups = groupedPresets.sorted(by: ascendingComparator(by: \.key))
                    ForEach(sortedGroups, id: \.key) { (group, presets) in
                        VStack {
                            Section(group) {
                                ForEach(presets) { preset in
                                    Button(preset.name) {
                                        do {
                                            viewModel.model = try preset.read()
                                        } catch {
                                            log.error("Could not read preset: \(error)")
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .buttonStyle(.bordered)
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
                    """
                    To add new nodes, hover one of the existing nodes and press the "+" handle on one of the four edges. A small popover should appear that lets you choose a node type.
                    
                    To remove a node, press the "x" button in the top right corner that appears when hovering a node.
                    
                    To add or remove edges, drag one of the "+" handles from one node onto another. Note that edges are directional and that cycles are not allowed.
                    
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
