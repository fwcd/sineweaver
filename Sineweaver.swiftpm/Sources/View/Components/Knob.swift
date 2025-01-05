//
//  Knob.swift
//  Sineweaver
//
//  Created on 05.01.25
//

import SwiftUI

struct Knob<Value>: View where Value: BinaryFloatingPoint {
    @Binding var value: Value
    var defaultValue: Value? = nil
    var range: ClosedRange<Value> = 0...1
    var sensitivity: Value = 1
    var halfCircleFraction: Double = 1 / 3
    var size: CGFloat = ComponentDefaults.knobSize
    
    @State private var delta: Value = 0
    
    private var valueWithDelta: Value {
        range.clamp(value + delta)
    }
    
    private var normalizedValue: Value {
        range.normalize(valueWithDelta)
    }
    
    private var circleFraction: Double {
        2 * halfCircleFraction
    }
    
    private var angularValue: Angle {
        .radians(Double(normalizedValue) * circleFraction * 2 * .pi)
    }
    
    private var startAngle: Angle {
        .radians(-halfCircleFraction * 2 * .pi)
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            let thickness = size / 16
            Circle()
                .fill(.gray.opacity(0.3))
                .frame(width: size, height: size)
            Arc(startAngle: .zero, endAngle: angularValue)
                .stroke(.foreground, lineWidth: thickness)
                .frame(width: size, height: size)
            Rectangle()
                .fill(.foreground)
                .frame(width: thickness, height: size * 0.4)
        }
        .rotationEffect(startAngle + angularValue)
        .gesture(
            TapGesture(count: 2)
                .onEnded {
                    resetToDefault()
                }
        )
        .simultaneousGesture(
            DragGesture()
                .onChanged { drag in
                    delta = Value(drag.translation.width - drag.translation.height) * 0.003 * sensitivity
                }
                .onEnded { _ in
                    value = valueWithDelta
                    delta = 0
                }
        )
        .contextMenu {
            Button("Set to Minimum Value") {
                value = range.lowerBound
            }
            Button("Set to Default Value") {
                resetToDefault()
            }
            .disabled(defaultValue == nil)
            Button("Set to Maximum Value") {
                value = range.upperBound
            }
        }
    }
    
    private func resetToDefault() {
        if let defaultValue {
            value = defaultValue
        }
    }
}

#Preview {
    @Previewable @State var value = 0.5
    
    Knob(value: $value)
}
