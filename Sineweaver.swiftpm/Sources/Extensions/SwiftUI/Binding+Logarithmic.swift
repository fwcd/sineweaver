//
//  LogarithmicBinding.swift
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
}
