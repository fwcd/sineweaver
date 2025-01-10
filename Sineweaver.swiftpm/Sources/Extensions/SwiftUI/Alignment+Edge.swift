//
//  Alignment+Edge.swift
//  Sineweaver
//
//  Created on 10.01.25
//

import SwiftUI

extension HorizontalAlignment {
    init(_ edge: HorizontalEdge) {
        switch edge {
        case .leading: self = .leading
        case .trailing: self = .trailing
        }
    }
}

extension VerticalAlignment {
    init(_ edge: VerticalEdge) {
        switch edge {
        case .top: self = .top
        case .bottom: self = .bottom
        }
    }
}
