//
//  Mutex.swift
//  Sineweaver
//
//  Created on 20.11.24
//

import Dispatch

final class Mutex<Value>: @unchecked Sendable {
    private let semaphore = DispatchSemaphore(value: 1)
    private var wrappedValue: Value
    
    @MainActor
    var onChange: (@Sendable () -> Void)?

    init(wrappedValue: Value, onChange: (@Sendable () -> Void)? = nil) {
        self.wrappedValue = wrappedValue
        self.onChange = onChange
    }
    
    func lock() -> Guard {
        Guard(parent: self)
    }
    
    class Guard {
        private let parent: Mutex<Value>
        
        var wrappedValue: Value {
            get { parent.wrappedValue }
            set {
                parent.wrappedValue = newValue
                let parent = parent
                Task { @MainActor in
                    parent.onChange?()
                }
            }
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
