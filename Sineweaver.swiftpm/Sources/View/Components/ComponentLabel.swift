//
//  ComponentLabel.swift
//  Sineweaver
//
//  Created on 27.12.24
//

import SwiftUI

struct ComponentLabel<Content>: View where Content: View {
    var orientation: Orientation = .horizontal
    @ViewBuilder let content: () -> Content

    enum Orientation: Hashable {
        case horizontal
        case vertical
    }
    
    var body: some View {
        Group {
            switch orientation {
            case .horizontal:
                content()
            case .vertical:
                VerticalLayout {
                    content()
                }
                .rotationEffect(.degrees(90))
            }
        }
        .textCase(.uppercase)
        .fontDesign(.monospaced)
    }
}

extension ComponentLabel where Content == Text {
    init(_ text: String = "", orientation: Orientation = .horizontal) {
        self.init(orientation: orientation) {
            Text(text)
        }
    }
}

#Preview {
    ComponentLabel("Hello, world!")
}
