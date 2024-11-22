//
//  Mutex.swift
//  Fourier Synth
//
//  Created on 20.11.24
//

import Dispatch

final class Mutex<Value>: @unchecked Sendable {
    private let semaphore = DispatchSemaphore(value: 1)
    private var wrappedValue: Value
    private let onChange: (@Sendable () -> Void)?

    init(wrappedValue: Value, onChange: (@Sendable () -> Void)? = nil) {
        self.wrappedValue = wrappedValue
        self.onChange = onChange
    }
    
    func lock() -> Guard {
        Guard(parent: self)
    }
    
    class Guard: Wrapper {
        private let parent: Mutex<Value>
        
        var wrappedValue: Value {
            get { parent.wrappedValue }
            set {
                parent.wrappedValue = newValue
                parent.onChange?()
            }
        }
        
        init(parent: Mutex<Value>) {
            self.parent = parent
            parent.semaphore.wait()
        }
        
        deinit {
            parent.semaphore.signal()
        }
    }
}
