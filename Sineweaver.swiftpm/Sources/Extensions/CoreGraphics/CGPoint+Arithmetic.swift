//
//  CGPoint+Arithmetic.swift
//  Sineweaver
//
//  Created on 24.11.24
//

import CoreGraphics

extension CGPoint {
    static func +(lhs: Self, rhs: Self) -> Self {
        Self(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
    
    static func -(lhs: Self, rhs: Self) -> CGVector {
        CGVector(dx: lhs.x - rhs.x, dy: lhs.y - rhs.y)
    }
    
    static func +(lhs: Self, rhs: CGVector) -> Self {
        Self(x: lhs.x + rhs.dx, y: lhs.y + rhs.dy)
    }
    
    static func -(lhs: Self, rhs: CGVector) -> Self {
        Self(x: lhs.x - rhs.dx, y: lhs.y - rhs.dy)
    }
    
    static func *(lhs: Self, rhs: Self) -> Self {
        Self(x: lhs.x * rhs.x, y: lhs.y * rhs.y)
    }
    
    static func /(lhs: Self, rhs: Self) -> Self {
        Self(x: lhs.x / rhs.x, y: lhs.y / rhs.y)
    }
    
    static func *(lhs: CGFloat, rhs: Self) -> Self {
        Self(x: lhs * rhs.x, y: lhs * rhs.y)
    }
    
    static func *(lhs: Self, rhs: CGFloat) -> Self {
        Self(x: lhs.x * rhs, y: lhs.y * rhs)
    }
    
    static func /(lhs: Self, rhs: CGFloat) -> Self {
        Self(x: lhs.x / rhs, y: lhs.y / rhs)
    }
    
    static func +=(lhs: inout Self, rhs: Self) {
        lhs = lhs + rhs
    }
    
    static func -=(lhs: inout Self, rhs: Self) {
        lhs = Self(lhs - rhs)
    }
    
    static func +=(lhs: inout Self, rhs: CGVector) {
        lhs = lhs + rhs
    }
    
    static func -=(lhs: inout Self, rhs: CGVector) {
        lhs = lhs - rhs
    }
    
    static func *=(lhs: inout Self, rhs: Self) {
        lhs = lhs * rhs
    }
    
    static func /=(lhs: inout Self, rhs: Self) {
        lhs = lhs / rhs
    }
    
    static func *=(lhs: inout Self, rhs: CGFloat) {
        lhs = lhs * rhs
    }
    
    static func /=(lhs: inout Self, rhs: CGFloat) {
        lhs = lhs / rhs
    }
}
