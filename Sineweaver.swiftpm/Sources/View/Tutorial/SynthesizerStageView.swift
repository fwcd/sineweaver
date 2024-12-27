//
//  SynthesizerStageView.swift
//  Sineweaver
//
//  Created on 25.12.24
//

import SwiftUI

struct SynthesizerStageView: View {
    let stage: SynthesizerStage
    // TODO: Use an actual oscillator
    
    @State private var node: OscillatorNode = .init(frequency: 50, volume: 1)
    
    var body: some View {
        SynthesizerOscillatorView(node: $node)
    }
}

#Preview {
    SynthesizerStageView(stage: .basicOscillator)
}
