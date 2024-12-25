//
//  ChartView.swift
//  Sineweaver
//
//  Created on 25.12.24
//

import SwiftUI

struct ChartView: View {
    var yRange: Range<Double>? = nil
    var sampleCount: Int = 100
    let function: (inout [Double]) -> Void
    
    private var ys: [Double] {
        var ys = [Double](repeating: 0, count: sampleCount)
        function(&ys)
        return ys
    }

    var body: some View {
        Canvas { ctx, size in
            let ys = self.ys
            let yRange = self.yRange ?? ((ys.min() ?? 0)..<(ys.max() ?? 1))
            
            ctx.stroke(Path { path in
                for (i, y) in ys.enumerated() {
                    path.addLine(to: CGPoint(
                        x: CGFloat(i) / CGFloat(sampleCount) * size.width,
                        y: CGFloat(normalize(y, in: yRange)) * size.height
                    ))
                }
            }, with: .foreground, lineWidth: 5)
        }
    }
}

extension ChartView {
    init(
        xRange: Range<Double> = 0..<1,
        yRange: Range<Double>? = nil,
        sampleCount: Int = 100,
        function: @escaping (Double) -> Double
    ) {
        self.init(yRange: yRange, sampleCount: sampleCount) { output in
            let step = (xRange.upperBound - xRange.lowerBound) / Double(output.count)
            for i in 0..<output.count {
                output[i] = function(Double(i) * step + xRange.lowerBound)
            }
        }
    }
}

#Preview {
    ChartView(xRange: 0..<(4 * .pi)) {
        sin($0)
    }
    .frame(width: 200, height: 200)
}
