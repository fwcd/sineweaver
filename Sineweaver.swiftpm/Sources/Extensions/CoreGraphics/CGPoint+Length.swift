//
//  CGPoint+Length.swift
//  Sineweaver
//
//  Created on 24.11.24
//

import CoreGraphics

extension CGPoint {
    var length: CGFloat {
        hypot(x, y)
    }
}
