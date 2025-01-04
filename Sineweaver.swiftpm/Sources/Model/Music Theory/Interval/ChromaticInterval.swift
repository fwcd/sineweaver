//
//  ChromaticInterval.swift
//  Sineweaver
//
//  Created on 04.01.25
//

/// An interval on the chromatic scale.
struct ChromaticInterval: Hashable, Sendable, Codable, AdditiveArithmetic {
    /// The empty chromatic interval.
    static let zero = Self(semitones: 0)

    /// The number of semitones that this interval represents.
    let semitones: Int

    static let semitone = Self(semitones: 1)

    init(semitones: Int) {
        self.semitones = semitones
    }

    static func semitones(_ n: Int) -> Self {
        Self(semitones: n)
    }

    prefix static func -(operand: Self) -> Self {
        Self(semitones: -operand.semitones)
    }

    static func +(lhs: Self, rhs: Self) -> Self {
        Self(semitones: lhs.semitones + rhs.semitones)
    }

    static func -(lhs: Self, rhs: Self) -> Self {
        Self(semitones: lhs.semitones - rhs.semitones)
    }
}

extension ChromaticInterval: RawRepresentable {
    var rawValue: Int { semitones }

    init(rawValue: Int) {
        self.init(semitones: rawValue)
    }
}
