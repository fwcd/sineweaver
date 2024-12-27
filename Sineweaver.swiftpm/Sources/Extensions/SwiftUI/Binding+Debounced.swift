//
//  Binding+Debounced.swift
//  Sineweaver
//
//  Created on 27.12.24
//

import SwiftUI

@MainActor
private final class Debouncer<Value> where Value: Sendable {
    private var immediateValue: Value
    private let timeout: Duration
    private let flush: (Value) -> Void
    
    var wrappedValue: Value {
        get { immediateValue }
        set {
            immediateValue = newValue
            timer?.cancel()
            timer = Task {
                do {
                    try await Task.sleep(for: timeout)
                    flush(immediateValue)
                } catch {}
            }
        }
    }
    
    private var timer: Task<Void, Never>? = nil
    
    init(immediateValue: Value, timeout: Duration, flush: @escaping (Value) -> Void) {
        self.immediateValue = immediateValue
        self.timeout = timeout
        self.flush = flush
    }
    
    deinit {
        timer?.cancel()
    }
}

extension Binding where Value: Sendable {
    @MainActor
    func debounced(timeout: Duration = .milliseconds(200)) -> Binding<Value> {
        let debouncer = Debouncer(immediateValue: wrappedValue, timeout: timeout) {
            wrappedValue = $0
        }
        return Binding {
            debouncer.wrappedValue
        } set: {
            debouncer.wrappedValue = $0
        }
    }
}
