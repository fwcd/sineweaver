//
//  SynthesizerNodeType+Icon.swift
//  Fourier Synth
//
//  Created on 23.11.24
//

import UIKit

extension SynthesizerNodeType {
    // TODO: Use better icons?
    
    var iconName: String {
        switch self {
        case .sine: "water.waves"
        case .silence: "speaker.slash"
        case .mixer: "arrow.trianglehead.merge"
        }
    }
}

extension UIImage {
    convenience init(_ nodeType: SynthesizerNodeType) {
        self.init(systemName: nodeType.iconName)!
    }
}
