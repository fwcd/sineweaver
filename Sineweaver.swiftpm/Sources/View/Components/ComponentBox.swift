//
//  ComponentBox.swift
//  Sineweaver
//
//  Created on 27.12.24
//

import SwiftUI

struct ComponentBox<Content, Label, Toolbar>: View where Content: View, Label: View, Toolbar: View {
    @ViewBuilder let content: () -> Content
    @ViewBuilder let label: () -> Label
    @ViewBuilder let toolbar: () -> Toolbar

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
                    .overlay(alignment: .topTrailing) {
                        toolbar()
                            .alignmentGuide(.top) { dimensions in
                                dimensions.height / 2
                            }
                            .padding(.horizontal, 5)
                            .background(.background)
                            .padding(.horizontal, 5)
                    }
            }
    }
}

extension ComponentBox where Toolbar == EmptyView {
    init(
        @ViewBuilder content: @escaping () -> Content,
        @ViewBuilder label: @escaping () -> Label
    ) {
        self.init(content: content, label: label) {}
    }
}

extension ComponentBox where Label == Text, Toolbar == EmptyView {
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
