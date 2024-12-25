//
//  Slider2D.swift
//  Sineweaver
//
//  Created on 25.12.24
//

import SwiftUI

struct Slider2D<Value, Background>: View
where Value: BinaryFloatingPoint,
      Background: ShapeStyle {
    @Binding var x: Value
    @Binding var y: Value
    let xOptions: AxisOptions
    let yOptions: AxisOptions
    var background: Background
    
    struct AxisOptions {
        var range: ClosedRange<Value> = -1...1
        var label: String? = nil
    }
    
    @State private var start: (x: Value, y: Value)? = nil

    var body: some View {
        let thumbSize: CGFloat = 20
        let width: CGFloat = 300
        let height: CGFloat = 300
        let labelPadding: CGFloat = 5
        Circle()
            .frame(width: thumbSize, height: thumbSize)
            .position(
                x: CGFloat(normalize(x, in: xOptions.range)) * width,
                y: CGFloat(1 - normalize(y, in: yOptions.range)) * height
            )
            .frame(width: width, height: height, alignment: .center)
            .background(background)
            .overlay(alignment: .trailing) {
                if let label = yOptions.label {
                    VerticalLayout {
                        Text(label)
                    }
                    .rotationEffect(.degrees(90))
                    .padding(labelPadding)
                }
            }
            .overlay(alignment: .bottom) {
                if let label = xOptions.label {
                    Text(label)
                        .padding(labelPadding)
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
                        x = start.x + Value(value.translation.width / width) * length(of: xOptions.range)
                        y = start.y - Value(value.translation.height / height) * length(of: yOptions.range)
                    }
                    .onEnded { value in
                        start = nil
                    }
            )
    }
}

extension Slider2D {
    init(
        x: Binding<Value>,
        in xRange: ClosedRange<Value> = AxisOptions().range,
        label xLabel: String? = AxisOptions().label,
        y: Binding<Value>,
        in yRange: ClosedRange<Value> = AxisOptions().range,
        label yLabel: String? = AxisOptions().label,
        background: Background
    ) {
        self.init(
            x: x,
            y: y,
            xOptions: .init(range: xRange, label: xLabel),
            yOptions: .init(range: yRange, label: yLabel),
            background: background
        )
    }
}

extension Slider2D where Background == HierarchicalShapeStyle {
    init(
        x: Binding<Value>,
        in xRange: ClosedRange<Value> = AxisOptions().range,
        label xLabel: String? = AxisOptions().label,
        y: Binding<Value>,
        in yRange: ClosedRange<Value> = AxisOptions().range,
        label yLabel: String? = AxisOptions().label
    ) {
        self.init(
            x: x,
            y: y,
            xOptions: .init(range: xRange, label: xLabel),
            yOptions: .init(range: yRange, label: yLabel),
            background: .tertiary
        )
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
