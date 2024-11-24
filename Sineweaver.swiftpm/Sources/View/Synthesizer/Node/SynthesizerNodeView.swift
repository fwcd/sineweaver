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
            Icon(systemName: node.type.iconName),
            Label(node.name),
        ]))
    }
    
    required init?(coder aDecoder: NSCoder) {
        nil
    }
}
