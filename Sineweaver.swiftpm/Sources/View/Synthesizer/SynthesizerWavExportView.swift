//
//  SynthesizerWavExportView.swift
//  Sineweaver
//
//  Created on 03.02.25
//

import SwiftUI
import UniformTypeIdentifiers

struct SynthesizerWavExportView: View {
    @Binding var node: WavExportNode
    
    @State private var filePickerShown = false
    
    var body: some View {
        Button(node.outputURL?.lastPathComponent ?? "Pick File...") {
            filePickerShown = true
        }
        .fileExporter(
            isPresented: $filePickerShown,
            document: DummyWavDocument(),
            contentType: .wav
        ) { result in
            if case let .success(url) = result {
                node.outputURL = url
            }
        }
    }
}

private struct DummyWavDocument: FileDocument {
    static var readableContentTypes: [UTType] { [.wav] }
    
    init() {}
    
    init(configuration: ReadConfiguration) throws {}
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        FileWrapper()
    }
}

#Preview {
    VStack {
        ForEach(MixerNode.Operation.allCases, id: \.self) { operation in
            SynthesizerMixerView(node: .constant(.init(operation: operation)))
        }
    }
}
