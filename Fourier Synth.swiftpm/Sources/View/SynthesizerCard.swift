//
//  SynthesizerCard.swift
//  Fourier Synth
//
//  Created on 22.11.24
//

import SwiftUI

struct SynthesizerCard<Content>: View where Content: View {
    var spacing: CGFloat = 10
    @ViewBuilder var content: () -> Content
    
    var body: some View {
        VStack(alignment: .center, spacing: spacing) {
            content()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(.primary.opacity(0.05))
        )
    }
}

#Preview {
    SynthesizerCard {
        Text("Test")
    }
}
