//
//  Dirtyable.swift
//  Fourier Synth
//
//  Created on 22.11.24
//

@propertyWrapper
struct Dirtyable<Value>: Wrapper {
    var wrappedValue: Value {
        didSet {
            isDirty = true
        }
    }
    
    var isDirty: Bool
}

extension Dirtyable: Sendable where Value: Sendable {}
