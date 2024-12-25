//
//  SynthesizerNodeType+Icon.swift
//  Sineweaver
//
//  Created on 23.11.24
//

import UIKit

extension SynthesizerNodeType {
    var iconName: String {
        switch self {
        case .oscillator: "waveform.path"
        case .silence: "speaker.slash"
        case .mixer: "plus.circle"
        }
    }
}

extension UIImage {
    convenience init(_ nodeType: SynthesizerNodeType) {
        self.init(systemName: nodeType.iconName)!
    }
}
