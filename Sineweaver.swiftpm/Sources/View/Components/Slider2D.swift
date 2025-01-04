//
//  Slider2D.swift
//  Sineweaver
//
//  Created on 25.12.24
//

import SwiftUI

struct Slider2D<Value, Background>: View where Value: BinaryFloatingPoint, Background: ShapeStyle {
    typealias AxisOptions = MultiSlider2D<Value, Background>.AxisOptions
    
    var size: CGFloat? = nil
    @Binding var x: Value
    @Binding var y: Value
    var axes: Vec2<AxisOptions>
    var background: Background
    var onPressChange: ((Bool) -> Void)? = nil
    
    @State private var isPressed = false
    
    var body: some View {
        MultiSlider2D(
            size: size,
            thumbPositions: Binding {
                [Vec2(x: x, y: y)]
            } set: {
                assert($0.count == 1)
                x = $0[0].x
                y = $0[0].y
            },
            axes: axes,
            background: background
        ) {
            onPressChange?($0 != nil)
        }
    }
}

extension Slider2D {
    init(
        size: CGFloat? = nil,
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
            size: size,
            x: x,
            y: y,
            axes: .init(
                x: .init(range: xRange, label: xLabel),
                y: .init(range: yRange, label: yLabel)
            ),
            background: background,
            onPressChange: onPressChange
        )
    }
}

extension Slider2D where Background == HierarchicalShapeStyle {
    init(
        size: CGFloat? = nil,
        x: Binding<Value>,
        in xRange: ClosedRange<Value> = AxisOptions().range,
        label xLabel: String? = AxisOptions().label,
        y: Binding<Value>,
        in yRange: ClosedRange<Value> = AxisOptions().range,
        label yLabel: String? = AxisOptions().label,
        onPressChange: ((Bool) -> Void)? = nil
    ) {
        self.init(
            size: size,
            x: x,
            y: y,
            axes: .init(
                x: .init(range: xRange, label: xLabel),
                y: .init(range: yRange, label: yLabel)
            ),
            background: ComponentDefaults.padBackground,
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
