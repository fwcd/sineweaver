import SwiftUI

private let synthesizer = try! Synthesizer()

@main
struct SineweaverApp: App {
    var body: some Scene {
        WindowGroup {
            SineweaverView()
                .environmentObject(synthesizer)
        }
    }
}
