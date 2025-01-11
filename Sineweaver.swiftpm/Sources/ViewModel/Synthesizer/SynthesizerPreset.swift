//
//  SynthesizerPreset.swift
//  Sineweaver
//
//  Created on 11.01.25
//

import Foundation

struct SynthesizerPreset: Identifiable {
    let name: String
    let url: URL
    
    var id: URL {
        url
    }
    
    private static let urlsInBundle: [URL] = Bundle.main.urls(forResourcesWithExtension: "json", subdirectory: nil) ?? []
    static let presetsInBundle: [Self] = urlsInBundle.map { Self(name: $0.deletingPathExtension().lastPathComponent, url: $0) }
    
    func read() throws -> SynthesizerModel {
        let data = try Data(contentsOf: url)
        return try SynthesizerModel(data: data)
    }
}
