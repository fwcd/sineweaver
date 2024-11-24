//
//  SceneInputHandler.swift
//  Sineweaver
//
//  Created on 24.11.24
//

import SpriteKit

@MainActor
protocol SceneInputHandler {
    func inputDown(at point: CGPoint)
    
    func inputDragged(to point: CGPoint)
    
    func inputUp(at point: CGPoint)
    
    func inputScrolled(deltaX: CGFloat, deltaY: CGFloat, deltaZ: CGFloat)
    
    func inputKeyDown(with keys: [KeyboardKey])
    
    func inputKeyUp(with keys: [KeyboardKey])
}

extension SceneInputHandler {
    func inputDown(at point: CGPoint) {}
    
    func inputDragged(to point: CGPoint) {}
    
    func inputUp(at point: CGPoint) {}
    
    func inputScrolled(deltaX: CGFloat, deltaY: CGFloat, deltaZ: CGFloat) {}
    
    func inputKeyDown(with keys: [KeyboardKey]) {}
    
    func inputKeyUp(with keys: [KeyboardKey]) {}
}
