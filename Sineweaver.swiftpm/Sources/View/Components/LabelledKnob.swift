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
    var onActiveChange: ((Bool) -> Void)? = nil
    var orientation: Orientation = .vertical
    var text: String? = nil
    var size: CGFloat = ComponentDefaults.knobSize
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
                    knob
                    VStack(alignment: .leading) {
                        labels
                    }
                }
            case .vertical:
                VStack(spacing: ComponentDefaults.smallVSpacing) {
                    knob
                    labels
                }
            }
        }
        .fixedSize()
    }
    
    @ViewBuilder
    private var knob: some View {
        Knob(value: $value, range: range, onActiveChange: onActiveChange, size: size)
    }
    
    @ViewBuilder
    private var labels: some View {
        if let text {
            ComponentLabel(text)
        }
        if let format {
            ComponentLabel(format(value), textCase: nil)
                .font(.system(size: 12))
        }
    }
}
