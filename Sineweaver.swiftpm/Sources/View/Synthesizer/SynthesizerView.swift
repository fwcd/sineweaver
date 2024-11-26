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
    
    private var nodeViewsById: [UUID: SKNode] = [:]
    private var edgeViewsById: [SynthesizerModel.Edge: SKNode] = [:]

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
    
    func sync(parentScene: SKScene) {
        print("Syncing synthesizer view...")
        
        let model = synthesizer.model.lock().wrappedValue
        
        func nodePhysicsBody(mass: CGFloat = 1) -> SKPhysicsBody {
            let physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 1, height: 1))
            physicsBody.mass = mass
            physicsBody.affectedByGravity = false
            physicsBody.allowsRotation = false
            physicsBody.linearDamping = 0.4
            physicsBody.angularDamping = 0.15
            return physicsBody
        }
        
        nodesParent.diffUpdate(nodes: &nodeViewsById, with: model.nodes) { nodeId, node in
            let isOutput = nodeId == model.outputNodeId
            let view = SynthesizerNodeView(node: node)
            view.physicsBody = nodePhysicsBody(mass: isOutput ? 1000 : 1)
            
            let angle = Double.random(in: 0...(2 * .pi))
            view.physicsBody!.applyImpulse(.init(dx: sin(angle), dy: sin(angle)))

            return view
        }
        
        // TODO: Cleanup old joints by tracking them instead of wiping everything which may affect other stuff
        let physicsWorld = parentScene.physicsWorld
//        physicsWorld.removeAllJoints()
        
        let maxLength: CGFloat = 150

        func joint(from srcBody: SKPhysicsBody, to destBody: SKPhysicsBody, maxLength: CGFloat = maxLength) -> SKPhysicsJointLimit {
            let joint = SKPhysicsJointLimit.joint(
                withBodyA: srcBody,
                bodyB: destBody,
                anchorA: CGPoint(),
                anchorB: CGPoint()
            )
            joint.maxLength = maxLength
            return joint
        }
        
        edgesParent.diffUpdate(nodes: &edgeViewsById, with: model.edges, id: \.self) { _, edge in
            let srcView = nodeViewsById[edge.srcId]!
            let destView = nodeViewsById[edge.destId]!
            physicsWorld.add(joint(from: srcView.physicsBody!, to: destView.physicsBody!))
            
            return SynthesizerEdgeView(srcView: srcView, destView: destView)
        }
        
//        let speakerView = SynthesizerOutputView()
//        speakerView.physicsBody = nodePhysicsBody(mass: 200)
//        nodesParent.addChild(speakerView)
//
//        if let outputId = model.outputNodeId, let outputView = views[outputId] {
//            physicsWorld.add(joint(from: outputView.physicsBody!, to: speakerView.physicsBody!))
//            edgesParent.addChild(SynthesizerEdgeView(srcView: outputView, destView: speakerView))
//        }
//        
//        speakerView.physicsBody!.applyImpulse(.init(dx: 0, dy: 0))
    }
    
    func update() {
        for (i, node1) in nodesParent.children.enumerated() {
            for node2 in nodesParent.children.dropFirst(i + 1) {
                let factor: CGFloat = 800
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
