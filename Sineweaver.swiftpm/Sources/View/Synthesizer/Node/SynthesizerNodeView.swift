//
//  SynthesizerNodeView.swift
//  Sineweaver
//
//  Created on 23.11.24
//

import SpriteKit

final class SynthesizerNodeView: SKNode {
    private let node: SynthesizerNode
    let isFixed: Bool
    
    init(node: SynthesizerNode, isFixed: Bool = false) {
        self.node = node
        self.isFixed = isFixed
        
        super.init()
        
        addChild(StackNode(.vertical, childs: [
            IconNode(systemName: node.type.iconName),
            LabelNode(node.name),
        ]))
    }
    
    required init?(coder aDecoder: NSCoder) {
        nil
    }
}
