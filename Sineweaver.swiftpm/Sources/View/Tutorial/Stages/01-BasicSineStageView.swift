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
    @State private var volume: Double = 1

    var body: some View {
        let group = Group {
            SynthesizerOscillatorView(node: OscillatorNode(
                frequency: frequency,
                volume: volume
            ))
            .frame(minWidth: 300)
            Slider2D(
                x: $frequency.logarithmic,
                in: log(20)...log(20000),
                y: $volume,
                in: 0...2
            )
        }
        ViewThatFits {
            HStack {
                group
            }
            VStack {
                group
            }
        }
    }
}

#Preview {
    BasicSineStageView()
}
