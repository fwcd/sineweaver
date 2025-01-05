//
//  VUMeter.swift
//  Sineweaver
//
//  Created on 05.01.25
//

import SwiftUI

struct VUMeter<Value>: View where Value: BinaryFloatingPoint {
    let value: Value
    var range: ClosedRange<Value> = 0...1
    
    var body: some View {
        let width = ComponentDefaults.meterThickness
        let height = ComponentDefaults.padSize
        let levelHeight = height * CGFloat(range.normalize(value))
        Rectangle()
            .fill(LinearGradient(stops: [
                .init(color: .green, location: 0),
                .init(color: .yellow, location: 0.9),
                .init(color: .red, location: 1),
            ], startPoint: .bottom, endPoint: .top))
            .clipShape(
                Rectangle()
                    .size(width: width, height: levelHeight)
                    .offset(y: height - levelHeight)
            )
            .frame(width: width, height: height, alignment: .bottom)
            .background(ComponentDefaults.padBackground.opacity(0.5))
    }
}

#Preview {
    HStack {
        let total = 10
        ForEach(0...total, id: \.self) { i in
            VUMeter(value: Double(i) / Double(total))
        }
    }
}
