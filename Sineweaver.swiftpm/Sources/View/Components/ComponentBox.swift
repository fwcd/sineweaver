//
//  ComponentBox.swift
//  Sineweaver
//
//  Created on 27.12.24
//

import SwiftUI

struct ComponentBox<Content, Label, Toolbar, Dock>: View where Content: View, Label: View, Toolbar: View, Dock: View {
    @ViewBuilder let content: () -> Content
    @ViewBuilder let label: () -> Label
    @ViewBuilder let toolbar: () -> Toolbar
    @ViewBuilder let dock: (Edge) -> Dock

    var body: some View {
        content()
            .padding()
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.foreground)
                    .overlay(alignment: .topLeading) {
                        aligned(.top) {
                            label()
                        }
                    }
                    .overlay(alignment: .top) {
                        aligned(.top) {
                            dock(.top)
                        }
                    }
                    .overlay(alignment: .topTrailing) {
                        aligned(.top) {
                            toolbar()
                        }
                    }
                    .overlay(alignment: .leading) {
                        aligned(.leading) {
                            dock(.leading)
                        }
                    }
                    .overlay(alignment: .trailing) {
                        aligned(.trailing) {
                            dock(.trailing)
                        }
                    }
                    .overlay(alignment: .bottom) {
                        aligned(.bottom) {
                            dock(.bottom)
                        }
                    }
            }
    }
    
    @ViewBuilder
    private func aligned(_ edge: Edge, @ViewBuilder content: () -> some View) -> some View {
        Group(subviews: content()) { subviews in
            if !subviews.isEmpty {
                subviews
                    .padding(2)
                    .background(RoundedRectangle(cornerRadius: 5).fill(.ultraThinMaterial))
                    .padding(Edge.Set.horizontal.contains(.init(edge)) ? .vertical : .horizontal, 10)
                    .fixedSize()
            }
        }
        .alignmentGuide(.leading) { $0[.leading] - (edge == .leading ? $0.width / 2 : 0) }
        .alignmentGuide(.trailing) { $0[.trailing] + (edge == .trailing ? $0.width / 2 : 0) }
        .alignmentGuide(.top) { $0[.top] + (edge == .top ? $0.height / 2 : 0) }
        .alignmentGuide(.bottom) { $0[.bottom] - (edge == .bottom ? $0.height / 2 : 0) }
    }
}

extension ComponentBox where Toolbar == EmptyView, Dock == EmptyView {
    init(
        @ViewBuilder content: @escaping () -> Content,
        @ViewBuilder label: @escaping () -> Label
    ) {
        self.init(content: content, label: label) {} dock: { _ in }
    }
}

extension ComponentBox where Label == Text, Toolbar == EmptyView, Dock == EmptyView {
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
