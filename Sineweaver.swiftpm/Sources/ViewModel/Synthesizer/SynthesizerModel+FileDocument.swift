//
//  SynthesizerModel+FileDocument.swift
//  Sineweaver
//
//  Created on 10.01.25
//

import SwiftUI
import UniformTypeIdentifiers

extension SynthesizerModel: FileDocument {
    static var contentType: UTType {
        .json
    }
    
    static var readableContentTypes: [UTType] {
        [contentType]
    }
    
    static var writableContentTypes: [UTType] {
        [contentType]
    }

    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents else {
            throw CocoaError(.fileReadCorruptFile)
        }
        try self.init(data: data)
    }
    
    init(data: Data) throws {
        self = try JSONDecoder().decode(SynthesizerModel.self, from: data)
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        guard let data = try? JSONEncoder().encode(self) else {
            throw CocoaError(.fileWriteUnknown)
        }
        let fileWrapper = FileWrapper(regularFileWithContents: data)
        return fileWrapper
    }
}
