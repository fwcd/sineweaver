import SwiftUI

@MainActor private let synthesizer = SynthesizerViewModel()
@MainActor private let tutorial = TutorialViewModel(synthesizer: synthesizer)

private class SceneDelegate: NSObject, UIWindowSceneDelegate {
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        #if targetEnvironment(macCatalyst)
        if let titlebar = windowScene.titlebar {
            titlebar.titleVisibility = .hidden
        }
        #endif
    }
}

private class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        let sceneConfig = UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
        sceneConfig.delegateClass = SceneDelegate.self
        return sceneConfig
    }
}

@main
struct SineweaverApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    
    var body: some Scene {
        WindowGroup {
            SineweaverView()
                .environmentObject(synthesizer)
                .environmentObject(tutorial)
        }
    }
}
