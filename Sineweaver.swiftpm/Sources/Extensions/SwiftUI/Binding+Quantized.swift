//
//  Binding+Quantized.swift
//  Sineweaver
//
//  Created on 25.12.24
//

import Foundation
import SwiftUI

extension Binding where Value: BinaryFloatingPoint & Sendable {
    var quantized: Binding<Int> {
        Binding<Int>(
            get: { Int(wrappedValue.rounded()) },
            set: { wrappedValue = Value($0) }
        )
    }
}

extension Binding where Value: BinaryInteger & Sendable {
    var dequantized: Binding<Double> {
        Binding<Double>(
            get: { Double(wrappedValue) },
            set: { wrappedValue = Value($0.rounded()) }
        )
    }
}
