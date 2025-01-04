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
    
    init(_ vec: Vec2<CGFloat>) {
        self.init(x: vec.x, y: vec.y)
    }
    
    init(_ vec: Vec2<Double>) {
        self.init(x: CGFloat(vec.x), y: CGFloat(vec.y))
    }
}
