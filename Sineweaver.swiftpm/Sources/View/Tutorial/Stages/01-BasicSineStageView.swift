//
//  01-BasicSineStageView.swift
//  Sineweaver
//
//  Created on 25.12.24
//

import SwiftUI

struct BasicSineStageView: View {
    // TODO: Use an actual oscillator
    
    @State private var frequency: Double = 440
    
    var body: some View {
        VStack {
            SynthesizerOscillatorView(node: SineNode(frequency: frequency))
            Slider(value: $frequency.logarithmic, in: log(20)...log(20000))
        }
    }
}

#Preview {
    BasicSineStageView()
}
