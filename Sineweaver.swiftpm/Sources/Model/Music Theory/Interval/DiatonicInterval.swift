//
//  DiatonicInterval.swift
//  Sineweaver
//
//  Created on 04.01.25
//

/// An interval on the diatonic scale.
struct DiatonicInterval: Hashable, Sendable, Codable {
    /// The total number of diatonic steps in this interval.
    let degrees: Int
    /// The total number of semitones in this interval.
    let semitones: Int

    // Main intervals
    static let unison = Self(degrees: 0, semitones: 0)
    static let minorSecond = Self(degrees: 1, semitones: 1)
    static let majorSecond = Self(degrees: 1, semitones: 2)
    static let minorThird = Self(degrees: 2, semitones: 3)
    static let majorThird = Self(degrees: 2, semitones: 4)
    static let perfectFourth = Self(degrees: 3, semitones: 5)
    static let augmentedFourth = Self(degrees: 3, semitones: 6)
    static let diminishedFifth = Self(degrees: 4, semitones: 6)
    static let perfectFifth = Self(degrees: 4, semitones: 7)
    static let minorSixth = Self(degrees: 5, semitones: 8)
    static let majorSixth = Self(degrees: 5, semitones: 9)
    static let minorSeventh = Self(degrees: 6, semitones: 10)
    static let majorSeventh = Self(degrees: 6, semitones: 11)
    static let octave = Self(degrees: 7, semitones: 12)

    // Main compound intervals
    static let minorNinth = Self(degrees: 8, semitones: 13)
    static let majorNinth = Self(degrees: 8, semitones: 14)
    static let minorTenth = Self(degrees: 9, semitones: 15)
    static let majorTenth = Self(degrees: 9, semitones: 16)
    static let perfectEleventh = Self(degrees: 10, semitones: 17)
    static let perfectTwelfth = Self(degrees: 11, semitones: 19) // also called 'tritave'
    static let minorThirteenth = Self(degrees: 12, semitones: 20)
    static let majorThirteenth = Self(degrees: 12, semitones: 21)
    static let minorFourteenth = Self(degrees: 13, semitones: 22)
    static let majorFourteenth = Self(degrees: 13, semitones: 23)
    static let doubleOctave = Self(degrees: 14, semitones: 24)

    prefix static func -(operand: Self) -> Self {
        return Self(degrees: -operand.degrees, semitones: -operand.semitones)
    }

    static func octaves(_ count: Int) -> Self {
        return Self(degrees: 7 * count, semitones: 12 * count)
    }
}
