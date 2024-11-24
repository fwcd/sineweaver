//
//  CGVector+Map.swift
//  Sineweaver
//
//  Created on 24.11.24
//

import CoreGraphics

extension CGVector {
    func map(_ transform: (CGFloat) throws -> CGFloat) rethrows -> Self {
        Self(
            dx: try transform(dx),
            dy: try transform(dy)
        )
    }
}
