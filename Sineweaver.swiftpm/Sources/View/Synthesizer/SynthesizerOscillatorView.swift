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
    
    @State private var baseOctave: Int = 3
    
    private var baseNote: Note {
        Note(.c, baseOctave)
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
    
    var body: some View {
        VStack(spacing: SynthesizerViewDefaults.vSpacing) {
            HStack(spacing: SynthesizerViewDefaults.hSpacing) {
                VStack {
                    SynthesizerChartView(node: playingNode)
                        .frame(minWidth: (node.prefersPianoView ? 1 : 1.25) * ComponentDefaults.padSize)
                        .opacity(node.isPlaying ? 1 : 0.5)
                    if node.prefersWavePicker {
                        HStack {
                            EnumPicker(selection: $node.wave, label: Text("Wave"))
                            Spacer()
                            if allowsEditing {
                                Stepper("Octave: \(baseNote)", value: $baseOctave, in: 0...9)
                                    .monospacedDigit()
                                    .fixedSize()
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
                    size: node.prefersPianoView ? 100 : 200,
                    x: $node.frequency.logarithmic,
                    in: log(20)...log(20000),
                    label: "Frequency",
                    y: $node.volume,
                    in: 0...1,
                    label: "Volume"
                ) { isPressed in
                    node.isPlaying = isPressed
                }
                .font(node.prefersPianoView ? .system(size: 8) : nil)
            }
            if node.prefersPianoView {
                PianoView(notes: baseNote..<(baseNote + .octaves(3))) { notes in
                    if let note = notes.first {
                        self.note = note
                    }
                    node.isPlaying = !notes.isEmpty
                }
            }
        }
        .onChange(of: baseNote) {
            note = baseNote
        }
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
