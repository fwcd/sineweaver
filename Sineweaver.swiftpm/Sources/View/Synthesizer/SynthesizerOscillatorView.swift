//
//  SynthesizerOscillatorView.swift
//  Sineweaver
//
//  Created on 25.12.24
//

import SwiftUI

struct SynthesizerOscillatorView: View {
    @Binding var node: OscillatorNode
    var allowsEditing: Bool = true
    var tuning: any Tuning = EqualTemperament()
    
    @State private var showsUnisonDetune = false
    
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

    private var playingNode: OscillatorNode {
        var node = node
        node.isPlaying = true
        return node
    }
    
    private var isCompact: Bool {
        allowsEditing || node.prefersPianoView
    }
    
    var body: some View {
        VStack(spacing: SynthesizerViewDefaults.vSpacing) {
            HStack(spacing: SynthesizerViewDefaults.hSpacing) {
                VStack {
                    SynthesizerChartView(node: playingNode)
                        .frame(minWidth: (isCompact ? 1 : 1.25) * ComponentDefaults.padSize)
                        .opacity(node.isPlaying ? 1 : 0.5)
                        .overlay(alignment: .trailing) {
                            Group {
                                if showsUnisonDetune {
                                    HStack {
                                        let knobSize = ComponentDefaults.knobSize * 0.6
                                        LabelledKnob(
                                            value: $node.unison.dequantized,
                                            range: 1...16,
                                            text: "Unison",
                                            size: knobSize
                                        )
                                        LabelledKnob(
                                            value: $node.detune,
                                            range: 0...1,
                                            text: "Detune",
                                            size: knobSize
                                        )
                                    }
                                    .padding(.leading, 5)
                                    .background(.background.opacity(0.9))
                                }
                            }
                            .animation(.default, value: showsUnisonDetune)
                        }
                        .onHover { hovered in
                            showsUnisonDetune = node.prefersUnisonDetuneControls && hovered
                        }
                    if node.prefersWavePicker {
                        HStack {
                            EnumPicker(selection: $node.wave, label: Text("Wave"))
                            Spacer()
                            if allowsEditing {
                                if node.prefersPianoView {
                                    OctavePicker(noteClass: pianoBaseNote.noteClass, octave: $node.pianoBaseOctave)
                                }
                                Button {
                                    node.prefersPianoView = !node.prefersPianoView
                                } label: {
                                    Image(systemName: node.prefersPianoView ? "chevron.up" : "chevron.down")
                                }
                            }
                        }
                        .overlay(alignment: .trailing) {
                            HStack(spacing: 20) {
                                HStack {
                                    Text("\(Int(node.frequency)) Hz")
                                    if node.prefersPianoView {
                                        Text("(aka. \(note))")
                                    }
                                }
                                Text(String(format: "%.2f dB", 10 * log10(node.volume)))
                            }
                            .font(.system(size: 14).monospacedDigit())
                            .padding(10)
                            .background(.ultraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .opacity(node.isPlaying ? 1 : 0)
                            .animation(.default, value: node.isPlaying)
                        }
                    }
                }
                Slider2D(
                    size: isCompact ? 100 : 200,
                    x: $node.frequency.logarithmic,
                    in: log(20)...log(20000),
                    label: "Frequency",
                    y: $node.volume,
                    in: 0...1,
                    label: "Volume"
                ) { isPressed in
                    node.isPlaying = isPressed
                }
                .font(isCompact ? .system(size: 8) : nil)
            }
            if node.prefersPianoView {
                PianoView(notes: pianoRange) { notes in
                    if let note = notes.first {
                        self.note = note
                    }
                    node.isPlaying = !notes.isEmpty
                }
            }
        }
        .onChange(of: node.pianoBaseOctave) {
            note = pianoBaseNote
        }
        .animation(.default, value: node.prefersPianoView)
    }
}

#Preview {
    @Previewable @State var nodes = OscillatorNode.Wave.allCases.map { OscillatorNode(wave: $0, frequency: 40) }
    
    VStack(spacing: 50) {
        ForEach(Array(nodes.indices), id: \.self) { i in
            SynthesizerOscillatorView(node: $nodes[i])
                .frame(maxHeight: 100)
        }
    }
}
