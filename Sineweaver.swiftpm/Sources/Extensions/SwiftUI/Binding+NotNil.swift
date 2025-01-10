//
//  Binding+NotNil.swift
//  Sineweaver
//
//  Created on 10.01.25
//

import SwiftUI

extension Binding where Value: OptionalProtocol & Sendable & Equatable {
    var notNil: Binding<Bool> {
        Binding<Bool> {
            wrappedValue != .none
        } set: {
            wrappedValue = $0 ? wrappedValue : .none
        }
    }
}
