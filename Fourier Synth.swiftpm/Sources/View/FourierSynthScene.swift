//
//  FourierSynthSwiftUI.swift
//  Fourier Synth
//
//  Created on 24.11.24
//

import SpriteKit

final class FourierSynthScene: SKScene {
    private let synthesizer: Synthesizer
    
    init(synthesizer: Synthesizer) {
        self.synthesizer = synthesizer
        // TODO: Figure out sizing
        super.init(size: CGSize(width: 640, height: 480))
        
        scaleMode = .aspectFill
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        let label = SKLabelNode(text: "Hello world")
        addChild(label)
        
        addChild(SynthesizerNodeView(node: .sine(.init())))
    }
    
    required init?(coder aDecoder: NSCoder) {
        nil
    }
}
