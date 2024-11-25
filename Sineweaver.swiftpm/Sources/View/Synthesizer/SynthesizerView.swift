//
//  SynthesizerView.swift
//  Sineweaver
//
//  Created on 24.11.24
//

import SpriteKit

final class SynthesizerView: SKNode, SceneInputHandler {
    private let synthesizer: Synthesizer
    
    private let nodesParent = SKNode()
    private let edgesParent = SKNode()
    
    private var dragState: DragState?
    
    private struct DragState {
        let node: SKNode
        let dragOffset: CGVector
        let savedMass: CGFloat
    }
    
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
        
        func nodePhysicsBody(isFixed: Bool) -> SKPhysicsBody {
            let physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 1, height: 1))
            physicsBody.mass = isFixed ? 100 : 1
            physicsBody.affectedByGravity = false
            physicsBody.allowsRotation = false
            physicsBody.linearDamping = 0.5
            physicsBody.angularDamping = 0.25
            return physicsBody
        }
        
        for (nodeId, node) in model.nodes {
            let isOutput = nodeId == model.outputNodeId
            let view = SynthesizerNodeView(node: node)
            view.position = CGPoint(x: Double.random(in: 0...0.05), y: Double.random(in: 0...0.05))
            view.physicsBody = nodePhysicsBody(isFixed: isOutput)
            
            views[nodeId] = view
            nodesParent.addChild(view)
        }
        
        // TODO: Cleanup old joints by tracking them instead of wiping everything which may affect other stuff
        let physicsWorld = parentScene.physicsWorld
        physicsWorld.removeAllJoints()

        func joint(from srcBody: SKPhysicsBody, to destBody: SKPhysicsBody, maxLength: CGFloat = 150) -> SKPhysicsJointLimit {
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
                if let srcView = views[srcId],
                   let destView = views[destId] {
                    physicsWorld.add(joint(from: srcView.physicsBody!, to: destView.physicsBody!))
                    
                    let edgeView = SynthesizerEdgeView(srcView: srcView, destView: destView)
                    edgesParent.addChild(edgeView)
                }
            }
        }
        
        let speakerView = SynthesizerOutputView()
        speakerView.physicsBody = nodePhysicsBody(isFixed: false)
        nodesParent.addChild(speakerView)

        if let outputId = model.outputNodeId, let outputView = views[outputId] {
            physicsWorld.add(joint(from: outputView.physicsBody!, to: speakerView.physicsBody!))
            edgesParent.addChild(SynthesizerEdgeView(srcView: outputView, destView: speakerView))
        }
    }
    
    func update() {
        // TODO: Track nodes properly
        
        for (i, node1) in nodesParent.children.enumerated() {
            for node2 in nodesParent.children.dropFirst(i + 1) {
                let factor: CGFloat = 200
                let force = (node1.position - node2.position).map { factor / $0 }
                node1.physicsBody!.applyForce(force)
                node2.physicsBody!.applyForce(-force)
            }
        }
        
        for edge in edgesParent.children {
            (edge as? SynthesizerEdgeView)?.update()
        }
    }
    
    func inputDown(at point: CGPoint) {
        // NOTE: nodesParent has the same coordinate system, so we omit the conversion out of convenience
        if let child = nodesParent.nodes(at: point).last {
            dragState = .init(
                node: child,
                dragOffset: child.position - point,
                savedMass: child.physicsBody!.mass
            )
            // Very high number, so the user can drag smoothly, but not infinity to avoid numeric issues
            child.physicsBody!.mass = 1e16
        }
    }
    
    func inputDragged(to point: CGPoint) {
        if let dragState {
            dragState.node.position = point + dragState.dragOffset
        }
    }
    
    func inputUp(at point: CGPoint) {
        if let dragState {
            dragState.node.physicsBody!.mass = dragState.savedMass
        }
        dragState = nil
    }
}
