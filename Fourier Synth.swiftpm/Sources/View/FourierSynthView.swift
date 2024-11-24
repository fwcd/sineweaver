import SpriteKit
import SwiftUI
import Charts
import Combine

struct FourierSynthView: View {
    @EnvironmentObject private var synthesizer: Synthesizer
    
    var body: some View {
        SpriteView(scene: FourierSynthScene(synthesizer: synthesizer))
    }
}
