import SpriteKit
import SwiftUI
import Charts
import Combine

struct SineweaverView: View {
    var body: some View {
        SpriteView(scene: SineweaverScene())
            .overlay(alignment: .bottom) {
                HStack {
                    Button {
                        // TODO
                    } label: {
                        Label("Add Node", systemImage: "plus")
                    }
                }
                .buttonStyle(.borderedProminent)
                .padding()
                .clipShape(RoundedRectangle(cornerRadius: ViewDefaults.cornerRadius))
                .padding()
            }
    }
}
