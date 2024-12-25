//
//  Slider2D.swift
//  Sineweaver
//
//  Created on 25.12.24
//

import SwiftUI

struct Slider2D<Value>: View where Value: BinaryFloatingPoint {
    @Binding private var x: Value
    @Binding private var y: Value
    private let xRange: ClosedRange<Value>
    private let yRange: ClosedRange<Value>
    private let xLabel: String?
    private let yLabel: String?
    
    @State private var start: (x: Value, y: Value)? = nil

    var body: some View {
        let thumbSize: CGFloat = 20
        let width: CGFloat = 300
        let height: CGFloat = 300
        Circle()
            .frame(width: thumbSize, height: thumbSize)
            .position(
                x: CGFloat(normalize(x, in: xRange)) * width,
                y: CGFloat(normalize(y, in: yRange)) * height
            )
            .frame(width: width, height: height, alignment: .center)
            .background(.gray)
            .overlay(alignment: .trailing) {
                if let yLabel {
                    VerticalLayout {
                        Text(yLabel)
                    }
                    .rotationEffect(.degrees(90))
                    .padding()
                }
            }
            .overlay(alignment: .bottom) {
                if let xLabel {
                    Text(xLabel)
                        .padding()
                }
            }
            .textCase(.uppercase)
            .fontDesign(.monospaced)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        if start == nil {
                            start = (x: x, y: y)
                        }
                        guard let start else { return }
                        x = start.x + Value(value.translation.width / width) * length(of: xRange)
                        y = start.y + Value(value.translation.height / height) * length(of: yRange)
                    }
                    .onEnded { value in
                        start = nil
                    }
            )
    }
    
    init(
        x: Binding<Value>,
        in xRange: ClosedRange<Value> = -1...1,
        label xLabel: String? = nil,
        y: Binding<Value>,
        in yRange: ClosedRange<Value> = -1...1,
        label yLabel: String? = nil
    ) {
        self._x = x
        self._y = y
        self.xRange = xRange
        self.yRange = yRange
        self.xLabel = xLabel
        self.yLabel = yLabel
    }
}

#Preview {
    @Previewable @State var x: Double = 0
    @Previewable @State var y: Double = 0
    
    VStack {
        Slider2D(x: $x, label: "Sample X", y: $y, label: "Sample Y")
        VStack(alignment: .leading) {
            Text("x = \(x)")
            Text("y = \(y)")
        }
        .fontDesign(.monospaced)
    }
}
