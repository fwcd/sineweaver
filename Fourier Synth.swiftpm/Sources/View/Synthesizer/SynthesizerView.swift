//
//  SynthesizerView.swift
//  Fourier Synth
//
//  Created on 24.11.24
//

import SpriteKit

final class SynthesizerView: SKNode {
    private let synthesizer: Synthesizer
    
    init(synthesizer: Synthesizer) {
        self.synthesizer = synthesizer
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        nil
    }
    
    // TODO: Delta sync

    func sync(parentScene: SKScene) {
        print("Syncing synthesizer view...")
        removeAllChildren()
        
        let model = synthesizer.model.lock().wrappedValue
        var views: [UUID: SynthesizerNodeView] = [:]
        
        for (nodeId, node) in model.nodes {
            let view = SynthesizerNodeView(node: node)
            
            let physicsBody = SKPhysicsBody()
            physicsBody.mass = 1
            physicsBody.affectedByGravity = false
            view.physicsBody = physicsBody
            
            views[nodeId] = view
            addChild(view)
            
            // FIXME: Remove this
            physicsBody.applyImpulse(CGVector(dx: .random(in: 0...100), dy: .random(in: 0...100)))
        }
        
        // TODO: Cleanup old joints by tracking them instead of wiping everything which may affect other stuff
        let physicsWorld = parentScene.physicsWorld
        physicsWorld.removeAllJoints()

        for (destId, srcIds) in model.inputEdges {
            for srcId in srcIds {
                let joint = SKPhysicsJointSpring()
                joint.bodyA = views[srcId]!.physicsBody!
                joint.bodyB = views[destId]!.physicsBody!
                physicsWorld.add(joint)
            }
        }
    }
}
