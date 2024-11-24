//
//  CGSize+Arithmetic.swift
//  Sineweaver
//
//  Created on 24.11.24
//

import CoreGraphics

extension CGSize {
    static func +(lhs: Self, rhs: Self) -> Self {
        Self(width: lhs.width + rhs.width, height: lhs.height + rhs.height)
    }
    
    static func -(lhs: Self, rhs: Self) -> Self {
        Self(width: lhs.width - rhs.width, height: lhs.height - rhs.height)
    }
    
    static func +(lhs: Self, rhs: CGVector) -> Self {
        Self(width: lhs.width + rhs.dx, height: lhs.height + rhs.dy)
    }
    
    static func -(lhs: Self, rhs: CGVector) -> Self {
        Self(width: lhs.width - rhs.dx, height: lhs.height - rhs.dy)
    }
    
    static func *(lhs: CGFloat, rhs: Self) -> Self {
        Self(width: lhs * rhs.width, height: lhs * rhs.height)
    }
    
    static func *(lhs: Self, rhs: CGFloat) -> Self {
        Self(width: lhs.width * rhs, height: lhs.height * rhs)
    }
    
    static func /(lhs: Self, rhs: CGFloat) -> Self {
        Self(width: lhs.width / rhs, height: lhs.height / rhs)
    }
    
    static func +=(lhs: inout Self, rhs: Self) {
        lhs = lhs + rhs
    }
    
    static func -=(lhs: inout Self, rhs: Self) {
        lhs = lhs - rhs
    }
    
    static func +=(lhs: inout Self, rhs: CGVector) {
        lhs = lhs + rhs
    }
    
    static func -=(lhs: inout Self, rhs: CGVector) {
        lhs = lhs - rhs
    }
    
    static func *=(lhs: inout Self, rhs: CGFloat) {
        lhs = lhs * rhs
    }
    
    static func /=(lhs: inout Self, rhs: CGFloat) {
        lhs = lhs / rhs
    }
}
