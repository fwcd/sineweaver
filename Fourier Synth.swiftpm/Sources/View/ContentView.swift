import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var synthesizer: Synthesizer
    
    var body: some View {
        VStack {
            TimelineView(.animation) { _ in
                Text(String(synthesizer.phase.lock().wrappedValue))
            }
        }
    }
}
