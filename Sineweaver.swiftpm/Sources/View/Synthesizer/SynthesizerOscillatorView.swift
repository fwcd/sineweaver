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
    
    @State private var unisonKnobActive = false
    @State private var detuneKnobActive = false
    @State private var isExpanded = false
    
    private var showsUnisonDetune: Bool {
        node.prefersUnisonDetuneControls
    }

    private var pianoBaseNote: Note {
        Note(.c, node.pianoBaseOctave)
    }
    
    private var pianoRange: Range<Note> {
        pianoBaseNote..<(pianoBaseNote + .octaves(3))
    }
    
    private var notes: [Note] {
        get {
            node.frequencies.map { frequency in
                Note(semitone: Int(tuning.semitone(for: frequency).rounded()))
            }
        }
        nonmutating set {
            node.frequencies = newValue.map(tuning.pitchHz(for:))
        }
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
                    HStack {
                        SynthesizerChartView(
                            node: playingNode,
                            displayInterval: SynthesizerViewDefaults.chartDisplayInterval * (showsUnisonDetune ? 0.5 : 1)
                        )
                        .opacity(node.isPlaying ? 1 : 0.5)
                        if showsUnisonDetune {
                            let knobSize = ComponentDefaults.knobSize * 0.6
                            LabelledKnob(
                                value: $node.unison.dequantized,
                                range: 1...16,
                                onActiveChange: { unisonKnobActive = $0 },
                                text: "Unison",
                                size: knobSize
                            )
                            LabelledKnob(
                                value: $node.detune,
                                range: 0...1,
                                onActiveChange: { detuneKnobActive = $0 },
                                text: "Detune",
                                size: knobSize
                            )
                        }
                    }
                    .frame(minWidth: (isCompact ? 1 : 1.25) * ComponentDefaults.padSize)
                    .animation(.default, value: showsUnisonDetune)
                    .onChange(of: unisonKnobActive || detuneKnobActive) {
                        node.isPlaying = unisonKnobActive || detuneKnobActive
                    }
                    if node.prefersWavePicker {
                        HStack {
                            EnumPicker(selection: $node.wave, label: Text("Wave"))
                            Spacer()
                            if allowsEditing {
                                if node.prefersPianoView {
                                    OctavePicker(noteClass: pianoBaseNote.noteClass, octave: $node.pianoBaseOctave)
                                    Button {
                                        isExpanded = !isExpanded
                                    } label: {
                                        Image(systemName: isExpanded ? "arrow.down.right.and.arrow.up.left" : "arrow.up.left.and.arrow.down.right")
                                    }
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
                                    if node.prefersPianoView, let note = notes.first {
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
                PianoView(notes: pianoRange, scale: isExpanded ? 2 : 1) { notes in
                    if !notes.isEmpty {
                        self.notes = notes.sorted()
                    }
                    node.isPlaying = !notes.isEmpty
                }
            }
        }
        .onChange(of: node.pianoBaseOctave) {
            notes = [pianoBaseNote]
        }
        .animation(.default, value: node.prefersPianoView)
        .animation(.default, value: isExpanded)
    }
}

#Preview {
    @Previewable @State var nodes = OscillatorNode.Wave.allCases.map { OscillatorNode(wave: $0, frequencies: [40]) }
    
    VStack(spacing: 50) {
        ForEach(Array(nodes.indices), id: \.self) { i in
            SynthesizerOscillatorView(node: $nodes[i])
                .frame(maxHeight: 100)
        }
    }
}
