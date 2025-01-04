//
//  CGVector+Conversions.swift
//  Sineweaver
//
//  Created on 24.11.24
//

import CoreGraphics

extension CGVector {
    init(_ point: CGPoint) {
        self.init(dx: point.x, dy: point.y)
    }
    
    init(_ size: CGSize) {
        self.init(dx: size.width, dy: size.height)
    }
    
    init(_ vec: Vec2<CGFloat>) {
        self.init(dx: vec.x, dy: vec.y)
    }
    
    init(_ vec: Vec2<Double>) {
        self.init(dx: CGFloat(vec.x), dy: CGFloat(vec.y))
    }
}
