//
//  LogarithmicBinding.swift
//  Sineweaver
//
//  Created on 25.12.24
//

import Foundation
import SwiftUI

@propertyWrapper
struct LogarithmicBinding<Value> where Value: BinaryFloatingPoint {
    private let binding: Binding<Value>
    
    var wrappedValue: Double {
        get { log(Double(binding.wrappedValue)) }
        set { binding.wrappedValue = Value(exp(newValue)) }
    }
    
    init(_ binding: Binding<Value>) {
        self.binding = binding
    }
}
