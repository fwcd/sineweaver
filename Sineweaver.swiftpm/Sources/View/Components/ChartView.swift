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
    var markedSample: Int? = nil
    var padding: CGFloat = 5
    let function: (inout [Double]) -> Void
    
    private var ys: [Double] {
        var ys = [Double](repeating: 0, count: sampleCount)
        function(&ys)
        return ys
    }

    var body: some View {
        Canvas { ctx, outerSize in
            let ys = self.ys
            let yRange = self.yRange ?? ((ys.min() ?? 0)..<(ys.max() ?? 1))
            
            let size = outerSize - CGVector(dx: 2 * padding, dy: 2 * padding)
            
            if let markedSample {
                let y = ys[markedSample]
                let displayY = (1 - CGFloat(yRange.normalize(y))) * size.height
                ctx.fill(Path(CGRect(
                    x: padding,
                    y: padding + displayY,
                    width: size.width,
                    height: size.height - displayY
                )), with: .linearGradient(Gradient(colors: [.gray.opacity(0.5), .gray.opacity(0.1)]), startPoint: CGPoint(x: 0, y: displayY), endPoint: CGPoint(x: 0, y: displayY + size.height)))
            }
            
            ctx.stroke(Path { path in
                for (i, y) in ys.enumerated() {
                    path.addLine(to: CGPoint(
                        x: padding + CGFloat(i) / CGFloat(sampleCount) * size.width,
                        y: padding + (1 - CGFloat(yRange.normalize(y))) * size.height
                    ))
                }
            }, with: .foreground, style: ComponentDefaults.lineStyle)
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
