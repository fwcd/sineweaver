//
//  SynthesizerPreset.swift
//  Sineweaver
//
//  Created on 11.01.25
//

import Foundation

struct SynthesizerPreset: Identifiable {
    let category: String
    let name: String
    let url: URL
    
    var id: URL {
        url
    }
    
    #if SINEWEAVER_AU
    private static let urlsInBundle: [URL] = [] // TODO: Figure out what the issue with the bundle is
    #else
    private static let urlsInBundle: [URL] = Bundle.main.urls(
        forResourcesWithExtension: "json",
        subdirectory: nil
    )?.sorted(by: ascendingComparator(by: \.absoluteString)) ?? []
    #endif
    
    static let presetsInBundle: [Self] = urlsInBundle.map { url -> Self in
        let rawName = url.deletingPathExtension().lastPathComponent
        let parsedName = rawName.split(separator: "_", maxSplits: 2).map { String($0) }
        return Self(
            category: parsedName[0],
            name: parsedName[1],
            url: url
        )
    }
    
    func read() throws -> SynthesizerModel {
        let data = try Data(contentsOf: url)
        return try SynthesizerModel(data: data)
    }
}
