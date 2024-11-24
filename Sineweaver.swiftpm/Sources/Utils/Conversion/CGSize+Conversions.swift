//
//  CGSize+Conversions.swift
//  Sineweaver
//
//  Created on 24.11.24
//

import CoreGraphics

extension CGSize {
    init(_ point: CGPoint) {
        self.init(width: point.x, height: point.y)
    }
    
    init(_ vector: CGVector) {
        self.init(width: vector.dx, height: vector.dy)
    }
}
