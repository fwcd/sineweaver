//
//  SynthesizerLFOView.swift
//  Sineweaver
//
//  Created on 25.12.24
//

import SwiftUI

struct SynthesizerLFOView: View {
    @Binding var node: OscillatorNode

    var body: some View {
        let size = ComponentDefaults.padSize / 2
        SynthesizerChartView(node: node, animated: true)
            .frame(width: size, height: size)
    }
}

#Preview {
    @Previewable @State var node = OscillatorNode(frequency: 0.5)
    
    SynthesizerLFOView(node: $node)
}
