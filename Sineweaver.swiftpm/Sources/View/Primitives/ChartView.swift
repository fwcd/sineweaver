//
//  ChartView.swift
//  Sineweaver
//
//  Created on 25.12.24
//

import SwiftUI

struct ChartView: View {
    var xRange: Range<Double> = 0..<1
    var yRange: Range<Double>? = nil
    var step: Double = 0.1
    let function: (Double) -> Double
    
    private var xs: [Double] {
        (0..<Int((xRange.upperBound - xRange.lowerBound) / step)).map { i in
            Double(i) * step + xRange.lowerBound
        }
    }
    
    private var ys: [Double] {
        xs.map(function)
    }

    var body: some View {
        Canvas { ctx, size in
            let xs = self.xs
            let ys = self.ys
            let xRange = self.xRange
            let yRange = self.yRange ?? ((ys.min() ?? 0)..<(ys.max() ?? 1))
            
            func normalize(_ x: Double, in range: Range<Double>) -> Double {
                (x - range.lowerBound) / (range.upperBound - range.lowerBound)
            }
            
            func toViewPoint(x: Double, y: Double) -> CGPoint {
                CGPoint(
                    x: CGFloat(normalize(x, in: xRange)) * size.width,
                    y: CGFloat(normalize(y, in: yRange)) * size.height
                )
            }
            
            ctx.stroke(Path { path in
                for (x, y) in zip(xs, ys) {
                    path.addLine(to: toViewPoint(x: x, y: y))
                }
            }, with: .foreground)
        }
    }
}

#Preview {
    ChartView(xRange: -10..<10) {
        sin($0)
    }
    .frame(width: 200, height: 200)
}
