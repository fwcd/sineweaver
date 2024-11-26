import SpriteKit
import SwiftUI
import Charts
import Combine

struct SineweaverView: View {
    @EnvironmentObject private var synthesizer: Synthesizer
    
    var body: some View {
        SpriteView(scene: SineweaverScene(synthesizer: synthesizer), debugOptions: .showsPhysics)
            .overlay(alignment: .bottom) {
                SineweaverToolbar()
                    .padding()
            }
    }
}
