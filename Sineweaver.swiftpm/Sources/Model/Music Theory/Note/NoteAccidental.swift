//
//  NoteAccidental.swift
//  Sineweaver
//
//  Created on 04.01.25
//

/// An accidental raises or lowers a note by a number of semitones.
struct NoteAccidental: CustomStringConvertible, Codable, Hashable, Sendable, Strideable, AdditiveArithmetic {
    /// The number of semitones the note in altered by. Sharp if > 0, flat if < 0.
    var semitones: Int

    static let doubleFlat = Self(semitones: -2)
    static let flat = Self(semitones: -1)
    static let unaltered = Self(semitones: 0)
    static let sharp = Self(semitones: 1)
    static let doubleSharp = Self(semitones: 2)

    /// The unaltered accidental.
    static let zero = unaltered

    /// This accidental sharpened by one semitone.
    var sharp: Self { Self(semitones: semitones + 1) }
    /// This accidental flattened by one semitone.
    var flat: Self { Self(semitones: semitones - 1) }

    /// Whether the accidental is unaltered/zero.
    var isUnaltered: Bool { semitones == 0 }

    /// The Western notation for this note accidental.
    var description: String {
        if semitones >= 0 {
            return String(repeating: "#", count: semitones)
        } else {
            return String(repeating: "b", count: -semitones)
        }
    }

    init(semitones: Int) {
        self.semitones = semitones
    }

    /// Parses an accidental from the given string.
    init?(_ rawString: String) {
        if let symbol = rawString.first {
            guard rawString.allSatisfy({ $0 == symbol }) else { return nil }

            let factor: Int
            switch symbol {
            case "#": factor = 1
            case "b": factor = -1
            default: return nil
            }

            semitones = rawString.count * factor
        } else {
            semitones = 0
        }
    }

    func advanced(by n: Int) -> Self {
        self + n
    }

    func distance(to other: Self) -> Int {
        other.semitones - semitones
    }

    static func +(lhs: Self, rhs: Int) -> Self {
        Self(semitones: lhs.semitones + rhs)
    }

    static func +=(lhs: inout Self, rhs: Int) {
        lhs.semitones += rhs
    }

    static func +(lhs: Self, rhs: Self) -> Self {
        Self(semitones: lhs.semitones + rhs.semitones)
    }

    static func -(lhs: Self, rhs: Self) -> Self {
        Self(semitones: lhs.semitones - rhs.semitones)
    }
}

extension NoteAccidental: RawRepresentable {
    var rawValue: Int { semitones }

    init(rawValue: Int) {
        self.init(semitones: rawValue)
    }
}
