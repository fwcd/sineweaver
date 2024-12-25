//
//  SynthesizerGraphView.swift
//  Sineweaver
//
//  Created on 25.12.24
//

import SwiftUI
import SpriteKit

struct SynthesizerGraphView: View {
    @Environment(SynthesizerViewModel.self) private var viewModel
    
    var body: some View {
        SpriteView(scene: SineweaverScene(synthesizer: viewModel.synthesizer), debugOptions: .showsPhysics)
            .overlay(alignment: .bottom) {
                SineweaverToolbar()
                    .padding()
            }
    }
}
