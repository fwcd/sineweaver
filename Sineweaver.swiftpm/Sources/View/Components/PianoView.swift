//
//  PianoView.swift
//  Sineweaver
//
//  Created on 04.01.25
//

import SwiftUI

/// A customizable piano keyboard with the ability to automatically play chords and highlight scales over a given note.
struct PianoView: View {
    private let notes: [Note]
    private let baseOctave: Int
    private let synthesizer: Synthesizer
    
    private let whiteKeySize: CGSize
    private let blackKeySize: CGSize
    
    private let updatePlaying: (Set<Note>) -> Void
    
    @Binding private var key: NoteClass
    
    @GestureState private var pressedKey: Note? = nil
    @State private var playingNotes: Set<Note> = []
    
    private var pressedNotes: Set<Note> {
        pressedKey.map { [$0] } ?? Set()
    }
    
    init(
        notes: some Sequence<Note>,
        baseOctave: Int,
        key: Binding<NoteClass>,
        synthesizer: Synthesizer,
        whiteKeySize: CGSize = CGSize(width: 20, height: 100),
        blackKeySize: CGSize = CGSize(width: 10, height: 80),
        updatePlaying: @escaping (Set<Note>) -> Void
    ) {
        self.notes = Array(notes)
        self.baseOctave = baseOctave
        self._key = key
        self.synthesizer = synthesizer
        self.whiteKeySize = whiteKeySize
        self.blackKeySize = blackKeySize
        self.updatePlaying = updatePlaying
    }
    
    var keyBounds: [(Note, CGRect)] {
        return notes.scan1({ (CGFloat(0), $0) }) { (entry, note) in
            let newX = entry.0 + (note.accidental.isUnaltered ? whiteKeySize.width : 0)
            return (newX, note)
        }.map { entry in
            let x = entry.0 + (entry.1.accidental.isUnaltered ? 0 : whiteKeySize.width - (blackKeySize.width / 2))
            let size = entry.1.accidental.isUnaltered ? whiteKeySize : blackKeySize
            return (entry.1, CGRect(origin: CGPoint(x: x, y: 0), size: size))
        }
    }
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            ForEach(keyBounds, id: \.0) { (note, bounds) in
                PianoKeyView(
                    note: note,
                    size: bounds.size,
                    pressed: playingNotes.contains(note),
                    enabled: true
                )
                .padding(.leading, bounds.minX)
                .zIndex(note.accidental.isUnaltered ? 0 : 1)
            }
        }
        .gesture(
            DragGesture(minimumDistance: 0, coordinateSpace: .local)
                .updating($pressedKey) { (value, state, _) in
                    let newPressed = self.keyBounds
                        .filter { $0.1.contains(value.location) }
                        .max(by: ascendingComparator { $0.0.accidental.isUnaltered ? 0 : 1 })?.0
                    // Only update the pressed state if we are not on a key that does not belong to the current scale
                    state = newPressed
                }
        )
        .onChange(of: playingNotes) {
            updatePlaying(playingNotes)
        }
    }
}
