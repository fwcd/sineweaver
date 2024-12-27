//
//  ComponentBox.swift
//  Sineweaver
//
//  Created on 27.12.24
//

import SwiftUI

struct ComponentBox<Content, Label>: View where Content: View, Label: View {
    @ViewBuilder let content: () -> Content
    @ViewBuilder let label: () -> Label

    var body: some View {
        content()
            .padding()
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.foreground)
                    .overlay(alignment: .topLeading) {
                        label()
                            .alignmentGuide(.top) { dimensions in
                                dimensions.height / 2
                            }
                            .padding(.horizontal, 5)
                            .background(.background)
                            .padding(.horizontal, 10)
                    }
            }
    }
}

extension ComponentBox where Label == Text {
    init(_ label: String = "", @ViewBuilder content: @escaping () -> Content) {
        self.init(content: content) {
            Text(label)
        }
    }
}

#Preview {
    ComponentBox("Box") {
        Text("ABC")
    }
}
