//
//  SynthesizerLevelView.swift
//  Sineweaver
//
//  Created on 05.01.25
//

import SwiftUI

struct SynthesizerLevelView: View {
    let level: Double
    
    var body: some View {
        VStack(spacing: SynthesizerViewDefaults.vSpacing) {
            VUMeter(value: level)
                .animation(.default, value: level)
                .frame(width: ComponentDefaults.padSize / 3)
            Text(String(format: "%.2f dB", 10 * log10(level)))
                .monospaced()
                .font(.system(size: 12))
        }
        .fixedSize()
    }
}
