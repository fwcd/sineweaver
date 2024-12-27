//
//  Debouncer.swift
//  Sineweaver
//
//  Created on 27.12.24
//

import SwiftUI

struct Debouncer<Value, Content>: View where Content: View {
    let timeout: Duration = .milliseconds(5)
    @Binding var wrappedValue: Value
    @ViewBuilder let content: (Binding<Value>) -> Content
    
    @State private var immediateValue: Value? = nil
    @State private var timer: Task<Void, Never>? = nil
    
    var body: some View {
        content(Binding {
            immediateValue ?? wrappedValue
        } set: {
            immediateValue = $0
            restartTimer()
        })
    }
    
    private func restartTimer() {
        timer?.cancel()
        timer = Task {
            do {
                try await Task.sleep(for: timeout)
                if !Task.isCancelled, let immediateValue {
                    wrappedValue = immediateValue
                }
            } catch {}
        }
    }
}
