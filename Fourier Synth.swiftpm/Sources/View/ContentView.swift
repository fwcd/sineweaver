import SwiftUI
import Charts
import Combine

struct ContentView: View {
    @EnvironmentObject private var synthesizer: Synthesizer
    
    var body: some View {
        HStack(spacing: 50) {
            // TODO: Render the nodes properly
            // TODO: Better order
            let model = synthesizer.model.lock().wrappedValue.wrappedValue
            ForEach(model.nodes.sorted { $0.key < $1.key }, id: \.key) { (_, node) in
                SynthesizerNodeView(node: node)
            }
            
            SynthesizerCard {
                SynthesizerCardIcon(systemName: "plus")
                Text("Add Node")
            }
            .opacity(0.5)
            
            SynthesizerCard {
                SynthesizerCardIcon(systemName: "hifispeaker")
                Text("Speaker Output")
            }
        }
    }
}
