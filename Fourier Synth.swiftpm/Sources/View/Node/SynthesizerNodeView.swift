//
//  SynthesizerNodeView.swift
//  Fourier Synth
//
//  Created on 23.11.24
//

import SpriteKit

final class SynthesizerNodeView: SKNode {
    init(node: SynthesizerNode) {
        super.init()
        
        let texture = SKTexture(image: UIImage(node.type))
        addChild(SKSpriteNode(texture: texture))
    }
    
    required init?(coder aDecoder: NSCoder) {
        nil
    }
}
