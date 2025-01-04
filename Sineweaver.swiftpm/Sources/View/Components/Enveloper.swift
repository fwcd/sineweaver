//
//  Enveloper.swift
//  Sineweaver
//
//  Created on 25.12.24
//

import SwiftUI

struct Enveloper<Value, Background>: View
where Value: BinaryFloatingPoint,
      Background: ShapeStyle {
    var size: CGFloat? = nil
    @Binding var thumbPositions: [Vec2<Value>]
    var background: Background
    var onPressChange: ((Bool) -> Void)? = nil
    
    @State private var isPressed = false
    
    struct AxisOptions {
        var range: ClosedRange<Value> = -1...1
        var label: String? = nil
    }
    
    var body: some View {
        let width: CGFloat = size ?? ComponentDefaults.padSize
        let height: CGFloat = size ?? width
        ZStack {
            ForEach(Array(thumbPositions.enumerated()), id: \.offset) { (i, pos) in
                Thumb()
            }
        }
        .frame(width: width, height: height, alignment: .center)
        .background(background)
    }
}

#Preview {
    @Previewable @State var thumbPositions: [Vec2<Double>] = [
        Vec2(x: 0, y: 0),
        Vec2(x: 0.1, y: 0),
        Vec2(x: 0, y: 0.1),
    ]
    
    // TODO: Convenience initializer for background
    Enveloper(thumbPositions: $thumbPositions, background: .tertiary)
}
