//
//  SynthesizerGraphView.swift
//  Sineweaver
//
//  Created on 24.11.24
//

import SpriteKit

final class SynthesizerGraphView: SKNode, SceneInputHandler {
    private let synthesizer: Synthesizer
    
    private let nodesParent = SKNode()
    private let edgesParent = SKNode()
    
    private var nodeViews: [UUID: SKNode] = [:]
    private var edgeViews: [SynthesizerModel.Edge: SKNode] = [:]
    private var edgeJoints: [SynthesizerModel.Edge: SKPhysicsJoint] = [:]

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
    
    private func nodePhysicsBody(mass: CGFloat = 1) -> SKPhysicsBody {
        let physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 1, height: 1))
        physicsBody.mass = mass
        physicsBody.affectedByGravity = false
        physicsBody.allowsRotation = false
        physicsBody.linearDamping = 0.4
        physicsBody.angularDamping = 0.15
        return physicsBody
    }
    
    func sync(parentScene: SKScene) {
        print("Syncing synthesizer view...")
        
        let model = synthesizer.model.lock().wrappedValue
        
        // Sync the node views
        let nodesUpdate = nodesParent.diffUpdate(nodes: &nodeViews, with: model.nodes) { nodeId, node in
            let isOutput = nodeId == model.outputNodeId
            let view = SynthesizerNodeView(node: node)
            view.physicsBody = nodePhysicsBody(mass: isOutput ? 1000 : 1)
            return view
        }
        
        // Break equilibrium to force node views to relayout
        for nodeId in nodesUpdate.addedIds {
            let angle = CGFloat.random(in: 0...(2 * .pi))
            let factor: CGFloat = 10
            nodeViews[nodeId]?.physicsBody?.applyImpulse(.init(dx: factor * cos(angle), dy: factor * sin(angle)))
        }
        
        // Sync the edge views
        edgesParent.diffUpdate(nodes: &edgeViews, with: model.edges, id: \.self) { _, edge in
            let srcView = nodeViews[edge.srcId]!
            let destView = nodeViews[edge.destId]!
            return SynthesizerEdgeView(srcView: srcView, destView: destView)
        }
        
        func joint(from src: SKNode, to dest: SKNode, maxLength: CGFloat = 150) -> SKPhysicsJointLimit {
            let joint = SKPhysicsJointLimit.joint(
                withBodyA: src.physicsBody!,
                bodyB: dest.physicsBody!,
                anchorA: src.position,
                anchorB: dest.position
            )
            joint.maxLength = maxLength
            return joint
        }

        // Sync the edge joints
        parentScene.physicsWorld.diffUpdate(nodes: &edgeJoints, with: model.edges, id: \.self) { _, edge in
            let srcView = nodeViews[edge.srcId]!
            let destView = nodeViews[edge.destId]!
            return joint(from: srcView, to: destView)
        }
    }
    
    func update() {
        for (i, node1) in nodesParent.children.enumerated() {
            for node2 in nodesParent.children.dropFirst(i + 1) {
                let factor: CGFloat = 2000
                let force = (node1.position - node2.position).map { factor / $0 }
                node1.physicsBody!.applyForce(force)
                node2.physicsBody!.applyForce(-force)
            }
        }
        
        // Uncomment to enable attractive forces between edges as an alternative to joints:
        for (edge, edgeView) in edgeViews {
            (edgeView as? SynthesizerEdgeView)?.update()
            // Uncomment to enable attractive forces between edges as an alternative to joints:
            // if let srcView = nodeViews[edge.srcId],
            //   let destView = nodeViews[edge.destId] {
            //    let factor: CGFloat = 0.5
            //    let force = (destView.position - srcView.position).map { factor * $0 }
            //    srcView.physicsBody!.applyForce(force)
            //    destView.physicsBody!.applyForce(-force)
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
