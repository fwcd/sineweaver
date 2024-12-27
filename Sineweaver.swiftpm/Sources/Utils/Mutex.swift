//
//  Mutex.swift
//  Sineweaver
//
//  Created on 20.11.24
//

import Dispatch

@propertyWrapper
final class Mutex<Value>: @unchecked Sendable {
    private let semaphore = DispatchSemaphore(value: 1)
    private var wrappedValueUnsafe: Value
    
    var wrappedValue: Value {
        get { lock().wrappedValue }
        set { lock().wrappedValue = newValue }
    }
    
    var projectedValue: Mutex<Value> {
        self
    }

    init(wrappedValue: Value) {
        wrappedValueUnsafe = wrappedValue
    }
    
    func lock() -> Guard {
        Guard(parent: self)
    }
    
    class Guard {
        private let parent: Mutex<Value>
        
        var wrappedValue: Value {
            get { parent.wrappedValueUnsafe }
            set { parent.wrappedValueUnsafe = newValue }
        }
        
        init(parent: Mutex<Value>) {
            self.parent = parent
            parent.semaphore.wait()
        }
        
        deinit {
            parent.semaphore.signal()
        }
        
        func useValue<T>(_ action: (inout Value) throws -> T) rethrows -> T {
            try action(&wrappedValue)
        }
    }
}
