//
//  SynthesizerFilterView.swift
//  Sineweaver
//
//  Created on 07.01.25
//

import SwiftUI

struct SynthesizerFilterView: View {
    @Binding var node: FilterNode
    
    var body: some View {
        // TODO: Something more fancy
        VStack(alignment: .leading, spacing: SynthesizerViewDefaults.vSpacing) {
            LabelledKnob(value: $node.filter.cutoffHz.logarithmic, range: log(20)...log(20_000), orientation: .horizontal, text: "Cutoff") { _ in
                String(format: "%.2f Hz", node.filter.cutoffHz)
            }
            LabelledKnob(value: $node.modulationFactor, orientation: .horizontal, text: "Modulation") {
                String(format: "%.2f", $0)
            }
        }
    }
}

#Preview {
    @Previewable @State var node = FilterNode()
    
    SynthesizerFilterView(node: $node)
}
