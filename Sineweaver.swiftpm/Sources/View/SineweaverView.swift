import SpriteKit
import SwiftUI
import Charts
import Combine

struct SineweaverView: View {
    @EnvironmentObject private var synthesizer: Synthesizer
    
    var body: some View {
        SpriteView(scene: SineweaverScene(synthesizer: synthesizer))
            .overlay(alignment: .bottom) {
                HStack {
                    Button {
                        // TODO
                    } label: {
                        Label("Add Node", systemImage: "plus")
                    }
                }
                .buttonStyle(.borderedProminent)
                .padding()
            }
    }
}
