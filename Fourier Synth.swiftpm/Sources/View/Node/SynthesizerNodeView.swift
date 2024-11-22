//
//  SynthesizerNodeView.swift
//  Fourier Synth
//
//  Created on 23.11.24
//

import SwiftUI

struct SynthesizerNodeView: View {
    // TODO: Make this a binding
    let node: SynthesizerNode
    
    var body: some View {
        SynthesizerCard {
            SynthesizerCardIcon(image: node.type.icon)
            Text(node.name)
        }
    }
}
