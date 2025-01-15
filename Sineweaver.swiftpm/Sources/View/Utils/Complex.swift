//
//  Complex.swift
//  Sineweaver
//
//  Created on 15.01.25
//

import Foundation

/// A complex number, i.e. an element of the algebraic closure of the real numbers.
public struct Complex: SignedNumeric, Hashable, ExpressibleByIntegerLiteral, ExpressibleByFloatLiteral, CustomStringConvertible, Sendable {
    public static let i = Self(0, i: 1)
    public var real: Double
    public var imag: Double
    public var description: String { "\(real) + \(imag)i" }
    public var magnitudeSquared: Double { (real * real) + (imag * imag) }
    public var magnitude: Double { magnitudeSquared.squareRoot() }
    public var absolute: Double { magnitude }
    public var squared: Self { self * self }
    public var conjugate: Self { Self(real, i: -imag) }

    public var exp: Self {
        guard imag != 0 else {
            return Self(Foundation.exp(real))
        }
        
        guard real != 0 else {
            return Self(cos(imag), i: sin(imag))
        }
        
        return Self(real).exp * Self(i: imag).exp
    }

    public init(_ real: Double = 0, i imag: Double = 0) {
        self.real = real
        self.imag = imag
    }

    public init<T: BinaryInteger>(exactly value: T) {
        self.init(Double(value))
    }

    public init(integerLiteral value: Int) {
        self.init(Double(value))
    }

    public init(floatLiteral value: Double) {
        self.init(value)
    }

    public static func +(lhs: Self, rhs: Self) -> Self {
        Self(lhs.real + rhs.real, i: lhs.imag + rhs.imag)
    }

    public static func -(lhs: Self, rhs: Self) -> Self {
        Self(lhs.real - rhs.real, i: lhs.imag - rhs.imag)
    }

    public static func +=(lhs: inout Self, rhs: Self) {
        lhs.real += rhs.real
        lhs.imag += rhs.imag
    }

    public static func -=(lhs: inout Self, rhs: Self) {
        lhs.real -= rhs.real
        lhs.imag -= rhs.imag
    }

    public static func *=(lhs: inout Self, rhs: Self) {
        let newReal = (lhs.real * rhs.real) - (lhs.imag * rhs.imag)
        let newImag = (lhs.real * rhs.imag) + (lhs.imag * rhs.real)
        lhs.real = newReal
        lhs.imag = newImag
    }

    public static func /=(lhs: inout Self, rhs: Self) {
        let denominator = (rhs.real * rhs.real) + (rhs.imag * rhs.imag)
        let newReal = ((lhs.real * rhs.real) + (lhs.imag * rhs.imag)) / denominator
        let newImag = ((lhs.imag * rhs.real) - (lhs.real * rhs.imag)) / denominator
        lhs.real = newReal
        lhs.imag = newImag
    }

    public static func *(lhs: Self, rhs: Double) -> Self {
        Self(lhs.real * rhs, i: lhs.imag * rhs)
    }

    public static func *(lhs: Self, rhs: Int) -> Self {
        lhs * Double(rhs)
    }

    public static func /(lhs: Self, rhs: Double) -> Self {
        Self(lhs.real / rhs, i: lhs.imag / rhs)
    }

    public static func /(lhs: Self, rhs: Int) -> Self {
        lhs / Double(rhs)
    }

    public static func *(lhs: Self, rhs: Self) -> Self {
        var result = lhs
        result *= rhs
        return result
    }

    public static func /(lhs: Self, rhs: Self) -> Self {
        var result = lhs
        result /= rhs
        return result
    }

    public mutating func negate() {
        real.negate()
        imag.negate()
    }

    public prefix static func -(operand: Self) -> Self {
        Self(-operand.real, i: -operand.imag)
    }

    public func equals(_ rhs: Self, accuracy: Double) -> Bool {
        (real - rhs.real).magnitude < accuracy && (imag - rhs.imag).magnitude < accuracy
    }
}
