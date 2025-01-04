//
//  Note.swift
//  Sineweaver
//
//  Created on 04.01.25
//

private let midiSemitoneOffset: Int = 12

/// A note is a named pitch or, viewed differently,
/// a note class with an octave in scientific pitch
/// notation.
struct Note: Codable, Hashable, Sendable, CustomStringConvertible {
    var noteClass: NoteClass
    var octave: Int

    /// The note's letter, taken from the note class.
    var letter: NoteLetter {
        get { noteClass.letter }
        set { noteClass.letter = newValue }
    }
    /// The note's accidental, taken from the note class.
    var accidental: NoteAccidental {
        get { noteClass.accidental }
        set { noteClass.accidental = newValue }
    }

    /// The absolute (octave-dependent) semitone that identifies the note's pitch uniquely on the keyboard
    var semitone: Int { (octave * NoteClass.twelveToneOctave.count) + noteClass.semitone }
    /// The absolute (octave-dependent) diatonic step of the note letter.
    var letterDegree: Int { (octave * NoteLetter.allCases.count) + letter.degree }
    /// The absolute (octave-dependent) semitone that identifies the note letter's pitch uniquely on the keyboard
    var letterSemitone: Int { (octave * NoteClass.twelveToneOctave.count) + letter.semitone }

    /// The MIDI note number.
    var midiNumber: Int { semitone + midiSemitoneOffset }

    /// The Western notation for this note.
    var description: String { "\(noteClass)\(octave)" }

    /// The canonical enharmonic equivalent of this note, which uses either zero or one flat.
    var canonicalized: Self {
        let step = accidental.semitones.signum()
        if step == 0 {
            return self
        } else {
            var note = self
            // TODO: Make this more efficient than linear time in the accidental
            while !(.flat...(.unaltered)).contains(note.accidental) {
                note = note.enharmonicEquivalent(diatonicSteps: step)
            }
            // Handle edge case where the flattened value can be further rewritten to an unaltered letter
            if note.accidental == .flat {
                let equivalent = note.enharmonicEquivalent(diatonicSteps: -1)
                if equivalent.accidental.isUnaltered {
                    return equivalent
                }
            }
            return note
        }
    }

    init(noteClass: NoteClass, octave: Int) {
        self.noteClass = noteClass
        self.octave = octave
    }

    /// Convenience initializer for brevity.
    init(_ noteClass: NoteClass, _ octave: Int) {
        self.init(noteClass: noteClass, octave: octave)
    }

    init(semitone: Int) {
        let count = NoteClass.twelveToneOctave.count
        self.init(
            noteClass: NoteClass(semitone: semitone.floorMod(count)),
            octave: semitone.floorDiv(count)
        )
    }

    init(midiNumber: Int) {
        self.init(semitone: midiNumber - midiSemitoneOffset)
    }

    /// Fetches the enharmonic equivalent with the specified number of diatonic steps above this note.
    func enharmonicEquivalent(diatonicSteps: Int) -> Self {
        // First compute the note with diatonicSteps letters above this one
        var newNote = Note(
            noteClass: NoteClass(letter: letter + diatonicSteps, accidental: accidental),
            octave: octave + (letter.degree + diatonicSteps).floorDiv(NoteLetter.allCases.count)
        )

        // Now we compute how many semitones we moved and subtract them from this accidental
        let semitoneDiff = letterSemitone - newNote.letterSemitone
        newNote.accidental = newNote.accidental + semitoneDiff

        return newNote
    }

    static func +(note: Self, interval: DiatonicInterval) -> Self {
        var newNote = note
        newNote.accidental += interval.semitones
        return newNote.enharmonicEquivalent(diatonicSteps: interval.degrees)
    }

    static func +(note: Self, interval: ChromaticInterval) -> Self {
        Note(semitone: note.semitone + interval.semitones)
    }

    static func +=(note: inout Self, interval: DiatonicInterval) {
        note = note + interval
    }

    static func +=(note: inout Self, interval: ChromaticInterval) {
        note = note + interval
    }

    static func -(note: Self, interval: DiatonicInterval) -> Self {
        note + (-interval)
    }

    static func -(note: Self, interval: ChromaticInterval) -> Self {
        note + (-interval)
    }

    static func -=(note: inout Self, interval: DiatonicInterval) {
        note += (-interval)
    }

    static func -=(note: inout Self, interval: ChromaticInterval) {
        note += (-interval)
    }
}

extension NoteClass {
    private var asNote: Note {
        Note(noteClass: self, octave: 0)
    }

    /// Fetches the enharmonic equivalent with the specified number of diatonic steps above this note.
    func enharmonicEquivalent(diatonicSteps: Int) -> Self {
        asNote.enharmonicEquivalent(diatonicSteps: diatonicSteps).noteClass
    }

    static func +(noteClass: Self, interval: DiatonicInterval) -> Self {
        (noteClass.asNote + interval).noteClass
    }

    static func +(noteClass: Self, interval: ChromaticInterval) -> Self {
        (noteClass.asNote + interval).noteClass
    }

    static func +=(noteClass: inout Self, interval: DiatonicInterval) {
        noteClass = noteClass + interval
    }

    static func +=(noteClass: inout Self, interval: ChromaticInterval) {
        noteClass = noteClass + interval
    }

    static func -(note: Self, interval: DiatonicInterval) -> Self {
        note + (-interval)
    }

    static func -(note: Self, interval: ChromaticInterval) -> Self {
        note + (-interval)
    }

    static func -=(note: inout Self, interval: DiatonicInterval) {
        note += (-interval)
    }

    static func -=(note: inout Self, interval: ChromaticInterval) {
        note += (-interval)
    }
}
