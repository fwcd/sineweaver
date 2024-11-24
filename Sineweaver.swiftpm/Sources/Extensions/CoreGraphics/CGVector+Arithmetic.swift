//
//  CGVector+Arithmetic.swift
//  Sineweaver
//
//  Created on 24.11.24
//

import CoreGraphics

extension CGVector {
    static func +(lhs: Self, rhs: Self) -> Self {
        Self(dx: lhs.dx + rhs.dx, dy: lhs.dy + rhs.dy)
    }
    
    static func -(lhs: Self, rhs: Self) -> Self {
        Self(dx: lhs.dx - rhs.dx, dy: lhs.dy - rhs.dy)
    }
    
    static func +(lhs: Self, rhs: CGSize) -> Self {
        Self(dx: lhs.dx + rhs.width, dy: lhs.dy + rhs.height)
    }
    
    static func -(lhs: Self, rhs: CGSize) -> Self {
        Self(dx: lhs.dx - rhs.width, dy: lhs.dy - rhs.height)
    }
    
    static func *(lhs: CGFloat, rhs: Self) -> Self {
        Self(dx: lhs * rhs.dx, dy: lhs * rhs.dy)
    }
    
    static func *(lhs: Self, rhs: Self) -> Self {
        Self(dx: lhs.dx * rhs.dx, dy: lhs.dy * rhs.dy)
    }
    
    static func /(lhs: Self, rhs: Self) -> Self {
        Self(dx: lhs.dx / rhs.dx, dy: lhs.dy / rhs.dy)
    }
    
    static func *(lhs: Self, rhs: CGFloat) -> Self {
        Self(dx: lhs.dx * rhs, dy: lhs.dy * rhs)
    }
    
    static func /(lhs: Self, rhs: CGFloat) -> Self {
        Self(dx: lhs.dx / rhs, dy: lhs.dy / rhs)
    }
    
    static func +=(lhs: inout Self, rhs: Self) {
        lhs = lhs + rhs
    }
    
    static func -=(lhs: inout Self, rhs: Self) {
        lhs = lhs - rhs
    }
    
    static func +=(lhs: inout Self, rhs: CGSize) {
        lhs = lhs + rhs
    }
    
    static func -=(lhs: inout Self, rhs: CGSize) {
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
