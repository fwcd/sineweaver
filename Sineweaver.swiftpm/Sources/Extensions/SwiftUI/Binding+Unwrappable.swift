//
//  Binding+Unwrappable.swift
//  Sineweaver
//
//  Created on 27.12.24
//

import SwiftUI

// Cannot conform to Unwrappable due to the Sendable constraint, unfortunately
extension Binding where Value: MutablyUnwrappable & Sendable {
    var unwrapped: Binding<Value.Wrapped> {
        Binding<Value.Wrapped> {
            wrappedValue.unwrapped
        } set: {
            wrappedValue.unwrapped = $0
        }
    }
}
