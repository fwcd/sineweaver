//
//  SynthesizerView.swift
//  Sineweaver
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
            view.position = CGPoint(x: Double.random(in: 0...0.05), y: Double.random(in: 0...0.05))
            
            let physicsBody = SKPhysicsBody()
            physicsBody.mass = 1
            physicsBody.affectedByGravity = false
            view.physicsBody = physicsBody
            
            views[nodeId] = view
            addChild(view)
        }
        
        // TODO: Cleanup old joints by tracking them instead of wiping everything which may affect other stuff
        let physicsWorld = parentScene.physicsWorld
        physicsWorld.removeAllJoints()

        for (destId, srcIds) in model.inputEdges {
            for srcId in srcIds {
                let srcBody = views[srcId]!.physicsBody!
                let destBody = views[destId]!.physicsBody!
                
                let joint = SKPhysicsJointLimit.joint(
                    withBodyA: srcBody,
                    bodyB: destBody,
                    anchorA: CGPoint(),
                    anchorB: CGPoint()
                )
                joint.maxLength = 100
                physicsWorld.add(joint)
            }
        }
    }
    
    func update() {
        // TODO: Track nodes properly
        
        for (i, node1) in children.enumerated() {
            for node2 in children.dropFirst(i + 1) {
                let force = (node1.position - node2.position).map { 1000 / $0 }
                node1.physicsBody!.applyForce(force)
                node2.physicsBody!.applyForce(-force)
            }
        }
    }
}
