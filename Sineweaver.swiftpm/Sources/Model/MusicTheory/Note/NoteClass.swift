//
//  NoteClass.swift
//  Sineweaver
//
//  Created on 04.01.25
//

/// A note without an octave. In contrast to a
/// (theoretical) pitch class, it does, however,
/// specify an enharmonic spelling.
struct NoteClass: Codable, Hashable, Sendable, CustomStringConvertible {
    static let c = Self(letter: .c)
    static let d = Self(letter: .d)
    static let e = Self(letter: .e)
    static let f = Self(letter: .f)
    static let g = Self(letter: .g)
    static let a = Self(letter: .a)
    static let b = Self(letter: .b)

    /// The twelve note classes with their canonical spellings.
    static let twelveToneOctave: [NoteClass] = [
        .c,
        .d.flat,
        .d,
        .e.flat,
        .e,
        .f,
        .g.flat,
        .g,
        .a.flat,
        .a,
        .b.flat,
        .b,
    ]

    var letter: NoteLetter
    var accidental: NoteAccidental

    /// This note class sharpened by one semitone.
    var sharp: Self { Self(letter: letter, accidental: accidental.sharp) }
    /// This note class flattened by one semitone.
    var flat: Self { Self(letter: letter, accidental: accidental.flat) }

    /// The semitone within a C major scale.
    var semitone: Int { letter.semitone + accidental.semitones }

    /// The Western notation for this note class.
    var description: String { "\(letter)\(accidental)" }

    init(letter: NoteLetter, accidental: NoteAccidental = .unaltered) {
        self.letter = letter
        self.accidental = accidental
    }

    init(semitone: Int) {
        let modSemitone = semitone.floorMod(Self.twelveToneOctave.count)
        self = Self.twelveToneOctave[modSemitone]
    }
}
