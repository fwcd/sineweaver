//
//  SynthesizerNoiseView.swift
//  Sineweaver
//
//  Created on 07.01.25
//

import SwiftUI

struct SynthesizerNoiseView: View {
    @Binding var node: NoiseNode
    
    var body: some View {
        LabelledKnob(value: $node.volume, text: "Volume") {
            String(format: "%.2f dB", 10 * log10($0))
        }
    }
}

#Preview {
    @Previewable @State var node = NoiseNode()
    
    SynthesizerNoiseView(node: $node)
}
