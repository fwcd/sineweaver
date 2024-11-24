//
//  SynthesizerView.swift
//  Sineweaver
//
//  Created on 24.11.24
//

import SpriteKit

final class SynthesizerView: SKNode {
    private let synthesizer: Synthesizer
    
    private let nodesParent = SKNode()
    private let edgesParent = SKNode()

    init(synthesizer: Synthesizer) {
        self.synthesizer = synthesizer
        
        super.init()
        
        addChild(nodesParent)
        addChild(edgesParent)
    }
    
    required init?(coder aDecoder: NSCoder) {
        nil
    }
    
    // TODO: Delta sync

    func sync(parentScene: SKScene) {
        print("Syncing synthesizer view...")
        nodesParent.removeAllChildren()
        edgesParent.removeAllChildren()

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
            nodesParent.addChild(view)
        }
        
        // TODO: Cleanup old joints by tracking them instead of wiping everything which may affect other stuff
        let physicsWorld = parentScene.physicsWorld
        physicsWorld.removeAllJoints()

        func joint(from srcBody: SKPhysicsBody, to destBody: SKPhysicsBody, maxLength: CGFloat) -> SKPhysicsJointLimit {
            let joint = SKPhysicsJointLimit.joint(
                withBodyA: srcBody,
                bodyB: destBody,
                anchorA: CGPoint(),
                anchorB: CGPoint()
            )
            joint.maxLength = maxLength
            return joint
        }
        
        for (destId, srcIds) in model.inputEdges {
            for srcId in srcIds {
                let srcView = views[srcId]!
                let destView = views[destId]!
                let srcBody = srcView.physicsBody!
                let destBody = destView.physicsBody!
                let length: CGFloat = 150
                physicsWorld.add(joint(from: srcBody, to: destBody, maxLength: length))
                
                let edgeView = SynthesizerEdgeView(srcView: srcView, destView: destView)
                edgesParent.addChild(edgeView)
            }
        }
    }
    
    func update() {
        // TODO: Track nodes properly
        
        for (i, node1) in nodesParent.children.enumerated() {
            for node2 in nodesParent.children.dropFirst(i + 1) {
                let force = (node1.position - node2.position).map { 1000 / $0 }
                node1.physicsBody!.applyForce(force)
                node2.physicsBody!.applyForce(-force)
            }
        }
        
        for edge in edgesParent.children {
            (edge as? SynthesizerEdgeView)?.update()
        }
    }
}
