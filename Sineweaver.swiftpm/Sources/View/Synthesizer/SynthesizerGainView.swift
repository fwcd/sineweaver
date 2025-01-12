//
//  SynthesizerGainView.swift
//  Sineweaver
//
//  Created on 07.01.25
//

import SwiftUI

struct SynthesizerGainView: View {
    @Binding var node: GainNode
    
    var body: some View {
        LabelledKnob(value: $node.gain.decibels, range: -20...6, text: "Gain") {
            String(format: "%.2f dB", $0)
        }
    }
}

#Preview {
    @Previewable @State var node = GainNode()
    
    SynthesizerGainView(node: $node)
}
