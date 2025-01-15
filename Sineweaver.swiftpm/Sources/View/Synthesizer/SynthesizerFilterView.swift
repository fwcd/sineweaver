//
//  SynthesizerFilterView.swift
//  Sineweaver
//
//  Created on 07.01.25
//

import SwiftUI

struct SynthesizerFilterView: View {
    @Binding var node: FilterNode
    var inputNodes: [SynthesizerNode] = []
    var startDate: Date = Date()
    var allowsEditing = true
    
    @State private var fftChartFrame: CGRect? = nil
    @State private var initialNodeCutoff: Double? = nil
    
    private var sampleRate: Double { 44_100 }
    private var minHz: Double { 20 }
    private var maxHz: Double { 20_000 }
    
    // TODO: It would be nice if we could generalize this properly to arbitrary nodes instead of recomputing the LFO here
    
    private var lfoModulation: LFONode? {
        guard inputNodes.count >= 2 else { return nil }
        let inputNode = inputNodes[1]
        guard inputNode.type == .lfo else { return nil }
        return inputNode.asLFO
    }
    
    var body: some View {
        // TODO: Show animated modulation on cutoff knob/in filter curve
        VStack(spacing: SynthesizerViewDefaults.vSpacing) {
            TimelineView(.animation) { context in
                let timeInterval = context.date.timeIntervalSince(startDate)
                let base: Double = 1.1
                let fft = filterFFT(for: modulated(filter: node.filter, at: timeInterval)).logarithmicallySampled(base: base)
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
                                node.filter.cutoffHz = (minHz...maxHz).clamp(
                                    initialNodeCutoff! * pow(base, Double(fft.count) * Double(drag.translation.width) / Double(fftChartFrame?.size.width ?? 1))
                                )
                            }
                            .onEnded { _ in
                                initialNodeCutoff = nil
                            }
                    )
            }
            HStack(spacing: SynthesizerViewDefaults.hSpacing) {
                LabelledKnob(value: $node.filter.cutoffHz.logarithmic, range: log(minHz)...log(maxHz), text: "Cutoff") { _ in
                    String(format: "%.2f Hz", node.filter.cutoffHz)
                }
                LabelledKnob(value: $node.modulationFactor, text: "Modulation") {
                    String(format: "%.2f", $0)
                }
            }
            EnumPicker(selection: $node.filter.kind)
        }
    }
    
    private func filterFFT(for filter: FilterNode.Filter) -> [Double] {
        let coeffs = filter.compute(sampleRate: sampleRate)
        let rawFFT = fft(coeffs.padded(to: coeffs.count.powerOfTwoCeil, with: 0).map { Complex($0) })
        return rawFFT[..<(rawFFT.count / 2)].map(\.magnitude)
    }
    
    private func modulation(at timeInterval: TimeInterval) -> Double {
        guard let lfoModulation else { return 0 }
        var state: Void = lfoModulation.makeState()
        let sampleCount = 1
        var output: [Double] = Array(repeating: 0, count: sampleCount)
        _ = lfoModulation.render(inputs: [], output: &output, state: &state, context: .init(
            frame: Int(timeInterval * sampleRate),
            sampleRate: Double(sampleRate)
        ))
        return output[0]
    }
    
    private func modulated(filter: FilterNode.Filter, at timeInterval: TimeInterval) -> FilterNode.Filter {
        var filter = filter
        filter.cutoffHz = (minHz...maxHz).clamp(node.modulate(cutoffHz: filter.cutoffHz, with: modulation(at: timeInterval)))
        return filter
    }
}

#Preview {
    @Previewable @State var node = FilterNode()
    
    SynthesizerFilterView(node: $node)
}
