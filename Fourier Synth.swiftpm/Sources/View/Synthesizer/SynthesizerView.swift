//
//  SynthesizerView.swift
//  Fourier Synth
//
//  Created on 24.11.24
//

import SpriteKit

final class SynthesizerView: SKNode {
    private let synthesizer: Synthesizer
    
    init(synthesizer: Synthesizer) {
        self.synthesizer = synthesizer
        super.init()
        sync()
    }
    
    required init?(coder aDecoder: NSCoder) {
        nil
    }
    
    // TODO: Delta sync

    func sync() {
        print("Syncing synthesizer view...")
        removeAllChildren()
        
        let model = synthesizer.model.lock().wrappedValue
        
        for (nodeId, node) in model.nodes {
            addChild(SynthesizerNodeView(node: node))
        }
    }
}
