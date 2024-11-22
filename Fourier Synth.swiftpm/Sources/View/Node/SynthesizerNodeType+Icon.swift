//
//  SynthesizerNodeType+Icon.swift
//  Fourier Synth
//
//  Created on 23.11.24
//

import SwiftUI

extension SynthesizerNodeType {
    var iconName: String {
        switch self {
        case .sine: "water.waves"
        case .silence: "speaker.slash"
        case .mixer: "arrow.trianglehead.merge"
        }
    }
    
    var icon: Image {
        Image(systemName: iconName)
    }
}
