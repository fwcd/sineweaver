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
    
    init(wrappedValue: Value) {
        self.wrappedValue = wrappedValue
    }
    
    func lock() -> Guard {
        Guard(parent: self)
    }
    
    class Guard {
        private let parent: Mutex<Value>
        
        var wrappedValue: Value {
            get { parent.wrappedValue }
            set { parent.wrappedValue = newValue }
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
