import SwiftUI
import Charts
import Combine

struct ContentView: View {
    @EnvironmentObject private var synthesizer: Synthesizer
    
    var body: some View {
        HStack(spacing: 50) {
            do {
                // TODO: Render the nodes properly
                // TODO: Better order
                let model = synthesizer.model.lock().wrappedValue.wrappedValue
                ForEach(model.nodes.sorted { $0.key < $1.key }, id: \.key) { (_, node) in
                    SynthesizerNodeView(node: node)
                }
            }
            
            SynthesizerCard {
                SynthesizerCardIcon(systemName: "plus")
                Text("Add Node")
            }
            .opacity(0.5)
            .onTapGesture {
                synthesizer.model.lock().wrappedValue.useValue { model in
                    // TODO: Other node types
                    if model.outputNodeId == nil {
                        model.outputNodeId = model.add(node: .mixer(.init()))
                    }
                    
                    let id = model.add(node: .sine(.init()))
                    model.connect(id, to: model.outputNodeId!)
                }
            }

            SynthesizerCard {
                SynthesizerCardIcon(systemName: "hifispeaker")
                Text("Speaker Output")
            }
        }
    }
}
