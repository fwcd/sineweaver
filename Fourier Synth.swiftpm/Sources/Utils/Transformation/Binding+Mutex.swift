//
//  Binding+Mutex.swift
//  Fourier Synth
//
//  Created on 20.11.24
//

import SwiftUI

extension Binding {
    init(_ mutex: Mutex<Value>) {
        self.init {
            mutex.lock().wrappedValue
        } set: {
            mutex.lock().wrappedValue = $0
        }
    }
}
