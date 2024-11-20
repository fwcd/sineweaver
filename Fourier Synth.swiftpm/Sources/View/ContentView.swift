import SwiftUI
import Charts
import Combine

struct ContentView: View {
    @State private var frequency: Float = 0
    @EnvironmentObject private var synthesizer: Synthesizer
    
    private let frequencyUpdateSubject = PassthroughSubject<Void, Never>()
    
    var body: some View {
        VStack {
            HStack {
                Slider(value: $frequency, in: 10...20_000)
                Text("\(frequency) Hz")
            }
            .frame(width: 300)
            
            TimelineView(.animation) { _ in
                let frame: Int = synthesizer.frame.lock().wrappedValue
                let sampleRate: Float = synthesizer.sampleRate
                let frequency: Float = synthesizer.frequency.lock().wrappedValue
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
        .onAppear {
            frequency = synthesizer.frequency.lock().wrappedValue
        }
        .onChange(of: frequency) {
            frequencyUpdateSubject.send()
        }
        .onReceive(frequencyUpdateSubject.debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)) {
            synthesizer.frequency.lock().wrappedValue = frequency
        }
    }
}
