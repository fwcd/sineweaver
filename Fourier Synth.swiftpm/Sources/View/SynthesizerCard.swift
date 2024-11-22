//
//  SynthesizerCard.swift
//  Fourier Synth
//
//  Created on 22.11.24
//

import SwiftUI

struct SynthesizerCard<Content>: View where Content: View {
    @ViewBuilder var content: () -> Content
    
    var body: some View {
        VStack(alignment: .center) {
            content()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(.background)
                .shadow(color: .gray.opacity(0.5), radius: 5)
        )
    }
}

#Preview {
    SynthesizerCard {
        Text("Test")
    }
}
