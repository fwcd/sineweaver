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
    
    private let whiteKeySize: CGSize
    private let blackKeySize: CGSize
    
    private let updatePlaying: (Set<Note>) -> Void
    
    @GestureState private var pressedKey: Note? = nil
    
    private var playingNotes: Set<Note> {
        pressedKey.map { [$0] } ?? Set()
    }
    
    init(
        notes: some Sequence<Note>,
        baseOctave: Int? = nil,
        whiteKeySize: CGSize = CGSize(width: 22, height: 80),
        blackKeySize: CGSize = CGSize(width: 12, height: 50),
        updatePlaying: @escaping (Set<Note>) -> Void
    ) {
        self.notes = Array(notes)
        self.baseOctave = baseOctave ?? self.notes.first?.octave ?? 0
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
        // TODO: Reimplement in terms of Canvas
        
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
                    state = newPressed
                }
        )
        .onChange(of: playingNotes) {
            updatePlaying(playingNotes)
        }
    }
}
