import SwiftUI

@main
struct FourierSynthApp: App {
    @StateObject private var synthesizer = try! Synthesizer()
    
    var body: some Scene {
        WindowGroup {
            FourierSynthView()
                .environmentObject(synthesizer)
        }
    }
}
