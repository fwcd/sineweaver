//
//  SynthesizerNodeType+Icon.swift
//  Sineweaver
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
        case .mixer: "plus.circle"
        }
    }
}

extension UIImage {
    convenience init(_ nodeType: SynthesizerNodeType) {
        self.init(systemName: nodeType.iconName)!
    }
}
