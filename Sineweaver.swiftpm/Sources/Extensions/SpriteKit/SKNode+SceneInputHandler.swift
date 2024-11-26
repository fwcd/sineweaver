//
//  SKNode+SceneInputHandler.swift
//  Sineweaver
//
//  Created on 24.11.24
//

import OSLog
import SpriteKit

private let log = Logger(subsystem: "Sineweaver", category: "SKNode+SceneInputHandler")

extension SKNode {
    public dynamic override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // log.debug("Touch began on \(self)")
        guard let touch = touches.first else { return }
        (self as? SceneInputHandler)?.inputDown(at: touch.location(in: self))
    }
    
    public dynamic override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // log.debug("Touch moved on \(self)")
        guard let touch = touches.first else { return }
        (self as? SceneInputHandler)?.inputDragged(to: touch.location(in: self))
    }
    
    public dynamic override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // log.debug("Touch ended on \(self)")
        guard let touch = touches.first else { return }
        (self as? SceneInputHandler)?.inputUp(at: touch.location(in: self))
    }
}
