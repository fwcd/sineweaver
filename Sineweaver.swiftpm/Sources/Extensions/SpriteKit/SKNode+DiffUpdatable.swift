//
//  SKNode+DiffUpdatable.swift
//  Sineweaver
//
//  Created on 26.11.24
//

import SpriteKit

extension SKNode: DiffUpdatable {
    func addChildForDiffUpdate(_ child: SKNode) {
        addChild(child)
    }
    
    func removeChildForDiffUpdate(_ child: SKNode) {
        child.removeFromParent()
    }
}
