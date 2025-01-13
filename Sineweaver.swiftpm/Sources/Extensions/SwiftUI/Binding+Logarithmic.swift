//
//  Binding+Logarithmic.swift
//  Sineweaver
//
//  Created on 25.12.24
//

import Foundation
import SwiftUI

extension Binding where Value: BinaryFloatingPoint & Sendable {
    var logarithmic: Binding<Double> {
        Binding<Double>(
            get: { log(Double(wrappedValue)) },
            set: { wrappedValue = Value(exp($0)) }
        )
    }
    
    var decibels: Binding<Double> {
        Binding<Double>(
            get: { 10 * log10(Double(wrappedValue)) },
            set: { wrappedValue = Value(pow(10, $0 / 10)) }
        )
    }
}
