import SpriteKit
import SwiftUI
import Charts
import Combine

struct SineweaverView: View {
    var body: some View {
        SpriteView(scene: SineweaverScene())
            .overlay(alignment: .bottomTrailing) {
                HStack {
                    Button("Test") {
                        print("Test")
                    }
                }
                .buttonStyle(.borderedProminent)
                .padding()
                .background(Color(ViewDefaults.quaternary))
                .clipShape(RoundedRectangle(cornerRadius: ViewDefaults.cornerRadius))
                .padding()
            }
    }
}
