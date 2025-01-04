//
//  Vec2.swift
//  Sineweaver
//
//  Created on 04.01.25
//

struct Vec2<Value> {
    var x: Value
    var y: Value
    
    func map<T>(_ transform: (Value) throws -> T) rethrows -> Vec2<T> {
        .init(x: try transform(x), y: try transform(y))
    }
    
    func zip<T, U>(_ other: Vec2<T>, _ combine: (Value, T) throws -> U) rethrows -> Vec2<U> {
        .init(x: try combine(x, other.x), y: try combine(y, other.y))
    }
    
    mutating func mapInPlace(_ transform: (Value) throws -> Value) rethrows {
        self = try map(transform)
    }
    
    mutating func zipInPlace<T>(_ other: Vec2<T>, _ combine: (Value, T) throws -> Value) rethrows {
        self = try zip(other, combine)
    }
}

extension Vec2: Equatable where Value: Equatable {}
extension Vec2: Hashable where Value: Hashable {}
extension Vec2: Sendable where Value: Sendable {}
extension Vec2: Encodable where Value: Encodable {}
extension Vec2: Decodable where Value: Decodable {}

extension Vec2: AdditiveArithmetic where Value: AdditiveArithmetic {
    static var zero: Self {
        .init(x: .zero, y: .zero)
    }
    
    static func +(lhs: Self, rhs: Self) -> Self {
        lhs.zip(rhs, +)
    }
    
    static func -(lhs: Self, rhs: Self) -> Self {
        lhs.zip(rhs, -)
    }
    
    static func +=(lhs: inout Self, rhs: Self) {
        lhs.zipInPlace(rhs, +)
    }
    
    static func -=(lhs: inout Self, rhs: Self) {
        lhs.zipInPlace(rhs, -)
    }
}

extension Vec2 where Value: SignedNumeric {
    static func *(lhs: Self, rhs: Value) -> Self {
        lhs.map { $0 * rhs }
    }
    
    static func *(lhs: Value, rhs: Self) -> Self {
        rhs.map { lhs * $0 }
    }
    
    static func *=(lhs: inout Self, rhs: Value) {
        lhs.mapInPlace { $0 * rhs }
    }
    
    static prefix func -(operand: Self) -> Self {
        operand.map { -$0 }
    }
    
    mutating func negate() {
        self = -self
    }
}

extension Vec2 where Value: BinaryFloatingPoint {
    static func /(lhs: Self, rhs: Value) -> Self {
        lhs.map { $0 / rhs }
    }
    
    static func /=(lhs: inout Self, rhs: Value) {
        lhs.mapInPlace { $0 / rhs }
    }
}
