//
//  SynthesizerEdgeSKNode.swift
//  Sineweaver
//
//  Created on 24.11.24
//

import SpriteKit

final class SynthesizerEdgeSKNode: SKNode {
    private let srcSKNode: SKNode
    private let destSKNode: SKNode
    
    init(srcSKNode: SKNode, destSKNode: SKNode) {
        self.srcSKNode = srcSKNode
        self.destSKNode = destSKNode
        
        super.init()
        
        let arrow = IconNode(systemName: "arrow.down")
        arrow.constraints = [.orient(to: destSKNode, offset: .init(constantValue: -.pi / 2))]
        addChild(arrow)
    }
    
    required init?(coder aDecoder: NSCoder) {
        nil
    }
    
    func update() {
        position = (srcSKNode.position + destSKNode.position) / 2
    }
}
