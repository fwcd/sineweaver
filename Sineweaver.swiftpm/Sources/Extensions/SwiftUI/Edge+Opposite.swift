//
//  Edge+Opposite.swift
//  Sineweaver
//
//  Created on 10.01.25
//

import SwiftUI

extension Edge {
    var opposite: Self {
        switch self {
        case .top: .bottom
        case .bottom: .top
        case .leading: .trailing
        case .trailing: .leading
        }
    }
}
