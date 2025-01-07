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
    var orientation: Orientation = .vertical
    var text: String? = nil
    var format: ((Value) -> String)? = nil
    
    enum Orientation: Hashable, CaseIterable {
        case horizontal
        case vertical
    }
    
    var body: some View {
        Group {
            switch orientation {
            case .horizontal:
                HStack(spacing: ComponentDefaults.smallHSpacing) {
                    content
                }
            case .vertical:
                VStack(spacing: ComponentDefaults.smallVSpacing) {
                    content
                }
            }
        }
        .fixedSize()
    }
    
    @ViewBuilder
    private var content: some View {
        Knob(value: $value, range: range)
        if let text {
            ComponentLabel(text)
        }
        if let format {
            ComponentLabel(format(value), textCase: nil)
                .font(.system(size: 12))
        }
    }
}
