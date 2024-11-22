//
//  SynthesizerCardIcon.swift
//  Fourier Synth
//
//  Created on 22.11.24
//

import SwiftUI

struct SynthesizerCardIcon: View {
    let image: Image
    
    var body: some View {
        image
            .font(.system(size: 64))
    }
}

extension SynthesizerCardIcon {
    init(systemName: String) {
        self.init(image: Image(systemName: systemName))
    }
}
