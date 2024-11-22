//
//  Wrapper.swift
//  Fourier Synth
//
//  Created on 23.11.24
//

protocol Wrapper<Value> {
    associatedtype Value
    var wrappedValue: Value { get set }
}

extension Wrapper {
    mutating func useValue(_ action: (inout Value) throws -> Void) rethrows {
        try action(&wrappedValue)
    }
}
