import SwiftUI
import Charts

struct ContentView: View {
    @EnvironmentObject private var synthesizer: Synthesizer
    
    var body: some View {
        VStack {
            TimelineView(.animation) { _ in
                let frame: Int = synthesizer.frame.lock().wrappedValue
                let frequency: Float = synthesizer.frequency.lock().wrappedValue
                let sampleRate: Float = synthesizer.sampleRate
                Chart {
                    LinePlot(x: "x", y: "y") { (x: Double) -> Double in
                        Double(Synthesizer.amplitude(
                            at: Float(frame) + Float(x),
                            frequency: frequency,
                            sampleRate: sampleRate
                        ))
                    }
                }
                .chartScrollPosition(x: .constant(Double(frame)))
                .chartXScale(domain: Double(frame)...(Double(frame) + 512))
                .chartYScale(domain: -1...1)
                .frame(width: 200, height: 200)
            }
        }
    }
}
