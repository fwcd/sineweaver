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
    
    @State private var isExpanded = false

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
        VStack(spacing: SynthesizerViewDefaults.vSpacing) {
            HStack(spacing: SynthesizerViewDefaults.hSpacing) {
                OctavePicker(noteClass: pianoBaseNote.noteClass, octave: $node.pianoBaseOctave)
                ExpansionToggle(isExpanded: $isExpanded)
            }
            PianoView(
                notes: pianoRange,
                scale: isExpanded ? SynthesizerViewDefaults.expandedPianoScale : 1
            ) { notes in
                if let note = notes.first {
                    self.note = note
                }
                node.isActive = !notes.isEmpty
            }
        }
        .animation(.default, value: isExpanded)
    }
}

#Preview {
    @Previewable @State var node = ControllerNode()
    
    SynthesizerControllerView(node: $node)
}
