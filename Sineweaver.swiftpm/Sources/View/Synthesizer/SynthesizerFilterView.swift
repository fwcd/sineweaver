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
    
    @State private var fftChartFrame: CGRect? = nil
    @State private var initialNodeCutoff: Double? = nil

    private var filterFFT: [Double] {
        let filter = node.filter.compute(sampleRate: 44_100)
        let rawFFT = fft(filter.padded(to: filter.count.powerOfTwoCeil, with: 0).map { Complex($0) })
        return rawFFT[..<(rawFFT.count / 2)].map(\.magnitude)
    }
    
    var body: some View {
        // TODO: Show animated modulation on cutoff knob/in filter curve
        VStack(spacing: SynthesizerViewDefaults.vSpacing) {
            let base = 1.1
            let fft = filterFFT.logarithmicallySampled(base: base)
            ChartView(ys: fft)
                .frame(height: ComponentDefaults.padSize / 4)
                .background(FrameReader(in: .local) { frame in
                    fftChartFrame = frame
                })
                .gesture(
                    DragGesture()
                        .onChanged { drag in
                            if initialNodeCutoff == nil {
                                initialNodeCutoff = node.filter.cutoffHz
                            }
                            node.filter.cutoffHz = initialNodeCutoff! * pow(base, Double(fft.count) * Double(drag.translation.width) / Double(fftChartFrame?.size.width ?? 1))
                        }
                        .onEnded { _ in
                            initialNodeCutoff = nil
                        }
                )
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
