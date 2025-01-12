//
//  Tip.swift
//  Sineweaver
//
//  Created on 12.01.25
//

import SwiftUI

struct Tip<Content>: View where Content: View {
    var color: Color = .gray
    var isAnimated = true
    @ViewBuilder var content: () -> Content
    
    @State private var offset: CGFloat = 0
    
    var body: some View {
        VStack(spacing: 10) {
            content()
            Image(systemName: "arrow.down")
                .offset(y: offset)
        }
        .foregroundStyle(color)
        .onAppear {
            if isAnimated {
                withAnimation(.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
                    offset = 5
                }
            }
        }
    }
}

extension Tip where Content == Text {
    init(_ text: String) {
        self.init {
            Text(text)
        }
    }
}

#Preview {
    Tip("Test")
}
