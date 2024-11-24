//
//  CGSize+Map.swift
//  Sineweaver
//
//  Created on 24.11.24
//

import CoreGraphics

extension CGSize {
    func map(_ transform: (CGFloat) throws -> CGFloat) rethrows -> Self {
        Self(
            width: try transform(width),
            height: try transform(height)
        )
    }
}
