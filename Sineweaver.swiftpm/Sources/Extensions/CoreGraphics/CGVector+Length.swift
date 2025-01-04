//
//  CGVector+Length.swift
//  Sineweaver
//
//  Created on 24.11.24
//

import CoreGraphics

extension CGVector {
    var length: CGFloat {
        hypot(dx, dy)
    }
}
