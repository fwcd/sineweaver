import SwiftUI

@MainActor
private let synthesizerViewModel = SynthesizerViewModel()

@MainActor
private let tutorialViewModel = TutorialViewModel()

@main
struct SineweaverApp: App {
    var body: some Scene {
        WindowGroup {
            SineweaverView()
                .environment(synthesizerViewModel)
                .environment(tutorialViewModel)
        }
    }
}
