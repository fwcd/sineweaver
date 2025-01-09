import SpriteKit
import SwiftUI
import Charts
import Combine

struct SineweaverView: View {
    var body: some View {
        TutorialView()
    }
}

#Preview {
    let synthesizer = SynthesizerViewModel()
    let tutorial = TutorialViewModel(synthesizer: synthesizer)
    SineweaverView()
        .environment(synthesizer)
        .environment(tutorial)
}
