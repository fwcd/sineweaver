//
//  SynthesizerNodeView.swift
//  Sineweaver
//
//  Created on 23.11.24
//

import SpriteKit

final class SynthesizerNodeView: SKNode {
    init(node: SynthesizerNode) {
        super.init()
        
        addChild(Stack(.vertical, childs: [
            SKSpriteNode(texture: SKTexture(image: UIImage(node.type))),
            Label(node.name),
        ]))
    }
    
    required init?(coder aDecoder: NSCoder) {
        nil
    }
}
