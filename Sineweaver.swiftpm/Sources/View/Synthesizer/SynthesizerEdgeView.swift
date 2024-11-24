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
        
        let arrow = IconNode(systemName: "arrow.down")
        arrow.constraints = [.orient(to: destView, offset: .init(constantValue: -.pi / 2))]
        addChild(arrow)
    }
    
    required init?(coder aDecoder: NSCoder) {
        nil
    }
    
    func update() {
        position = (srcView.position + destView.position) / 2
    }
}
