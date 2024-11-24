//
//  CGPoint+Map.swift
//  Sineweaver
//
//  Created on 24.11.24
//

import CoreGraphics

extension CGPoint {
    func map(_ transform: (CGFloat) throws -> CGFloat) rethrows -> Self {
        Self(
            x: try transform(x),
            y: try transform(y)
        )
    }
}
