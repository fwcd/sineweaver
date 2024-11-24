//
//  CGPoint+Conversions.swift
//  Sineweaver
//
//  Created on 24.11.24
//

import CoreGraphics

extension CGPoint {
    init(_ vector: CGVector) {
        self.init(x: vector.dx, y: vector.dy)
    }
    
    init(_ size: CGSize) {
        self.init(x: size.width, y: size.height)
    }
}
