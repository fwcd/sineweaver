//
//  SendableAtomic.swift
//  Sineweaver
//
//  Created on 10.01.25
//

import Synchronization

final class SendableAtomic<Value>: Sendable where Value: AtomicRepresentable & Sendable {
    let wrappedAtomic: Atomic<Value>
    
    init(_ value: Value) {
        wrappedAtomic = .init(value)
    }
}
