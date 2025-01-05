//
//  ComponentDefaults.swift
//  Sineweaver
//
//  Created on 04.01.25
//

import SwiftUI

enum ComponentDefaults {
    static let padBackground: HierarchicalShapeStyle = .tertiary
    static let meterThickness: CGFloat = 8
    static let padSize: CGFloat = 300
    static let lineStyle: StrokeStyle = .init(lineWidth: 4, lineJoin: .round)
    static let labelPadding: CGFloat = 5
    static let thumbSize: CGFloat = 20
    static let thumbLabelSpacing: CGFloat = 1.5 * thumbSize
    static let knobSize: CGFloat = 40
    static let highlightColor = Color.cyan
}
