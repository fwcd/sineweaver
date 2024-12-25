//
//  SynthesizerNodeSKNode.swift
//  Sineweaver
//
//  Created on 23.11.24
//

import SpriteKit

final class SynthesizerNodeSKNode: SKNode {
    private let node: SynthesizerNode
    
    init(node: SynthesizerNode) {
        self.node = node
        
        super.init()
        
        addChild(StackNode(.vertical, children: [
            IconNode(systemName: node.type.iconName),
            LabelNode(node.name),
        ]))
    }
    
    required init?(coder aDecoder: NSCoder) {
        nil
    }
}
