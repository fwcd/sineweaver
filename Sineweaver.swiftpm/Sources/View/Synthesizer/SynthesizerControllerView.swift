//
//  SynthesizerControllerView.swift
//  Sineweaver
//
//  Created on 11.01.25
//

import SwiftUI

struct SynthesizerControllerView: View {
    @Binding var node: ControllerNode
    var tuning: any Tuning = EqualTemperament()

    private var pianoBaseNote: Note {
        Note(.c, node.pianoBaseOctave)
    }
    
    private var pianoRange: Range<Note> {
        pianoBaseNote..<(pianoBaseNote + .octaves(3))
    }
    
    private var note: Note {
        get { Note(semitone: Int(tuning.semitone(for: node.frequency).rounded())) }
        nonmutating set { node.frequency = tuning.pitchHz(for: newValue) }
    }
    
    var body: some View {
        VStack {
            OctavePicker(noteClass: pianoBaseNote.noteClass, octave: $node.pianoBaseOctave)
            PianoView(notes: pianoRange) { notes in
                if let note = notes.first {
                    self.note = note
                }
                node.isActive = !notes.isEmpty
            }
        }
    }
}

#Preview {
    @Previewable @State var node = ControllerNode()
    
    SynthesizerControllerView(node: $node)
}
