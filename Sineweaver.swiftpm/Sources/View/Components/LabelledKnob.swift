//
//  LabelledKnob.swift
//  Sineweaver
//
//  Created on 06.01.25
//

import SwiftUI

struct LabelledKnob<Value>: View where Value: BinaryFloatingPoint {
    @Binding var value: Value
    var range: ClosedRange<Value> = 0...1
    var text: String? = nil
    var format: ((Value) -> String)? = nil
    
    var body: some View {
        VStack(spacing: ComponentDefaults.smallVSpacing) {
            Knob(value: $value, range: range)
            if let text {
                ComponentLabel(text)
            }
            if let format {
                ComponentLabel(format(value), textCase: nil)
                    .font(.system(size: 12))
            }
        }
        .fixedSize()
    }
}
