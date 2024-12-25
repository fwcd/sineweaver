//
//  01-BasicSineStageView.swift
//  Sineweaver
//
//  Created on 25.12.24
//

import SwiftUI

struct BasicSineStageView: View {
    // TODO: Use an actual oscillator
    
    var body: some View {
        SynthesizerOscillatorView(node: SineNode())
    }
}

#Preview {
    BasicSineStageView()
}
