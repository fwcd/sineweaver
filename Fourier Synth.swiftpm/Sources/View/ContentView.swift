import SwiftUI
import Charts

struct ContentView: View {
    @EnvironmentObject private var synthesizer: Synthesizer
    
    var body: some View {
        VStack {
            TimelineView(.animation) { _ in
                let phase = synthesizer.phase.lock().wrappedValue
                Chart {
                    LinePlot(x: "x", y: "y") {
                        sin($0)
                    }
                }
                .chartScrollPosition(x: .constant(phase))
                .chartXScale(domain: phase...(phase + 2 * .pi))
                .frame(width: 200, height: 200)
            }
        }
    }
}
