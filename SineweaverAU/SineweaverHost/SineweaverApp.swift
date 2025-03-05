//
//  SineweaverApp.swift
//  Sineweaver
//
//  Created on 04.03.25
//

import SwiftUI

@main
struct SineweaverApp: App {
    @State private var hostModel = AudioUnitHostModel()

    var body: some Scene {
        WindowGroup {
            ContentView(hostModel: hostModel)
        }
    }
}
