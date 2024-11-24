//
//  SynthesizerEdgeView.swift
//  Sineweaver
//
//  Created on 24.11.24
//

import SpriteKit

final class SynthesizerEdgeView: SKNode {
    private let srcView: SynthesizerNodeView
    private let destView: SynthesizerNodeView
    
    init(srcView: SynthesizerNodeView, destView: SynthesizerNodeView) {
        self.srcView = srcView
        self.destView = destView
        
        super.init()
        
        addChild(SKSpriteNode(texture: SKTexture(image: UIImage(systemName: "arrow.right")!)))
    }
    
    required init?(coder aDecoder: NSCoder) {
        nil
    }
    
    func update() {
        position = (srcView.position + destView.position) / 2
    }
}
