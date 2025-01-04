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
    var onPressChange: ((Bool) -> Void)? = nil
    
    @State private var isPressed = false
    
    struct AxisOptions {
        var range: ClosedRange<Value> = -1...1
        var label: String? = nil
    }
    
    var body: some View {
        let width: CGFloat = 300
        let height: CGFloat = 300
        let labelPadding: CGFloat = 5
        SliderThumb()
            .position(
                x: CGFloat(xOptions.range.normalize(x)) * width,
                y: CGFloat(1 - yOptions.range.normalize(y)) * height
            )
            .frame(width: width, height: height, alignment: .center)
            .background(background)
            .overlay(alignment: .trailing) {
                if let label = yOptions.label {
                    ComponentLabel(label, orientation: .vertical)
                        .padding(labelPadding)
                }
            }
            .overlay(alignment: .bottom) {
                if let label = xOptions.label {
                    ComponentLabel(label)
                        .padding(labelPadding)
                }
            }
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        if !isPressed {
                            isPressed = true
                        }
                        x = xOptions.range.clamp(xOptions.range.denormalize(Value(value.location.x / width)))
                        y = yOptions.range.clamp(yOptions.range.denormalize(Value(1 - value.location.y / height)))
                    }
                    .onEnded { _ in
                        isPressed = false
                    }
            )
            .onChange(of: isPressed) {
                onPressChange?(isPressed)
            }
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
        background: Background,
        onPressChange: ((Bool) -> Void)? = nil
    ) {
        self.init(
            x: x,
            y: y,
            xOptions: .init(range: xRange, label: xLabel),
            yOptions: .init(range: yRange, label: yLabel),
            background: background,
            onPressChange: onPressChange
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
        label yLabel: String? = AxisOptions().label,
        onPressChange: ((Bool) -> Void)? = nil
    ) {
        self.init(
            x: x,
            y: y,
            xOptions: .init(range: xRange, label: xLabel),
            yOptions: .init(range: yRange, label: yLabel),
            background: .tertiary,
            onPressChange: onPressChange
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
