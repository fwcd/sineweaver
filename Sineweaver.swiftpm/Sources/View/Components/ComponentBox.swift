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
    @ViewBuilder let dock: (Alignment) -> Dock

    var body: some View {
        content()
            .padding()
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.foreground)
                    .overlay(alignment: .topLeading) {
                        label()
                            .boxBoundAligned(.top)
                    }
                    .overlay(alignment: .top) {
                        alignedDock(.top)
                    }
                    .overlay(alignment: .topTrailing) {
                        toolbar()
                            .boxBoundAligned(.top)
                    }
                    .overlay(alignment: .leading) {
                        alignedDock(.leading)
                    }
                    .overlay(alignment: .trailing) {
                        alignedDock(.trailing)
                    }
                    .overlay(alignment: .bottom) {
                        alignedDock(.bottom)
                    }
            }
    }
    
    @ViewBuilder
    private func alignedDock(_ alignment: HorizontalAlignment) -> some View {
        Group(subviews: dock(.init(horizontal: alignment, vertical: .center))) { subviews in
            if !subviews.isEmpty {
                subviews
                    .boxBoundAligned(alignment)
            }
        }
    }
    
    @ViewBuilder
    private func alignedDock(_ alignment: VerticalAlignment) -> some View {
        Group(subviews: dock(.init(horizontal: .center, vertical: alignment))) { subviews in
            if !subviews.isEmpty {
                subviews
                    .boxBoundAligned(alignment)
            }
        }
    }
}

private let boundPadding: CGFloat = 2
private let boundMargin: CGFloat = 5

private func boundViewBackground() -> some View {
    RoundedRectangle(cornerRadius: 5).fill(.ultraThinMaterial)
}

private extension View {
    @ViewBuilder
    func boxBoundAligned(_ alignment: VerticalAlignment) -> some View {
        alignmentGuide(alignment) { dimensions in
            dimensions.height / 2
        }
        .padding(boundPadding)
        .background(boundViewBackground())
        .padding(.horizontal, boundMargin)
        .fixedSize()
    }
    
    @ViewBuilder
    func boxBoundAligned(_ alignment: HorizontalAlignment) -> some View {
        alignmentGuide(alignment) { dimensions in
            dimensions.width / 2
        }
        .padding(boundPadding)
        .background(boundViewBackground())
        .padding(.vertical, boundMargin)
        .fixedSize()
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
