import SwiftUI

@MainActor private let synthesizer = SynthesizerViewModel()
@MainActor private let tutorial = TutorialViewModel(synthesizer: synthesizer)

@main
struct SineweaverApp: App {
    var body: some Scene {
        WindowGroup {
            SineweaverView()
                .environment(synthesizer)
                .environment(tutorial)
        }
    }
}
