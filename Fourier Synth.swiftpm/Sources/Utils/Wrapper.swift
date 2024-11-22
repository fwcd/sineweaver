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
    mutating func useValue<T>(_ action: (inout Value) throws -> T) rethrows -> T {
        try action(&wrappedValue)
    }
}
