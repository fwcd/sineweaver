//
//  SynthesizerOutputView.swift
//  Sineweaver
//
//  Created on 25.11.24
//

import SpriteKit

final class SynthesizerOutputView: SKNode {
    override init() {
        super.init()
        
        addChild(StackNode(.vertical, childs: [
            IconNode(systemName: "hifispeaker"),
            LabelNode("Output"),
        ]))
    }
    
    required init?(coder aDecoder: NSCoder) {
        nil
    }
}
