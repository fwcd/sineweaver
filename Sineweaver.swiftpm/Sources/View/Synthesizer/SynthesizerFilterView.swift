//
//  SynthesizerFilterView.swift
//  Sineweaver
//
//  Created on 07.01.25
//

import SwiftUI

struct SynthesizerFilterView: View {
    @Binding var node: FilterNode
    var allowsEditing = true
    
    var body: some View {
        // TODO: Render filter curve
        // TODO: Show animated modulation on cutoff knob/in filter curve
        VStack(spacing: SynthesizerViewDefaults.vSpacing) {
            HStack(spacing: SynthesizerViewDefaults.hSpacing) {
                LabelledKnob(value: $node.filter.cutoffHz.logarithmic, range: log(20)...log(20_000), text: "Cutoff") { _ in
                    String(format: "%.2f Hz", node.filter.cutoffHz)
                }
                LabelledKnob(value: $node.modulationFactor, text: "Modulation") {
                    String(format: "%.2f", $0)
                }
            }
            EnumPicker(selection: $node.filter.kind)
        }
    }
}

#Preview {
    @Previewable @State var node = FilterNode()
    
    SynthesizerFilterView(node: $node)
}
