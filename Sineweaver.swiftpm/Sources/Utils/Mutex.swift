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
    private var changeListeners: [@Sendable () -> Void] = []

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
            set {
                parent.wrappedValue = newValue
                for listener in parent.changeListeners {
                    listener()
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
        
        func onChange(_ action: @Sendable @escaping () -> Void) {
            parent.changeListeners.append(action)
        }
        
        func useValue<T>(_ action: (inout Value) throws -> T) rethrows -> T {
            try action(&wrappedValue)
        }
    }
}
