//
//  SynthesizerGraphSKNode.swift
//  Sineweaver
//
//  Created on 24.11.24
//

import SpriteKit

final class SynthesizerGraphSKNode: SKNode, SceneInputHandler {
    private let synthesizer: Synthesizer
    
    private let nodesParent = SKNode()
    private let edgesParent = SKNode()
    
    private var nodeSKNodes: [UUID: SKNode] = [:]
    private var edgeSKNodes: [SynthesizerModel.Edge: SKNode] = [:]
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
        
        let model = synthesizer.$model.lock().wrappedValue
        
        // Sync the node views
        let nodesUpdate = nodesParent.diffUpdate(nodes: &nodeSKNodes, with: model.nodes) { nodeId, node in
            let isOutput = nodeId == model.outputNodeId
            let skNode = SynthesizerNodeSKNode(node: node)
            skNode.physicsBody = nodePhysicsBody(mass: isOutput ? 1000 : 1)
            return skNode
        }
        
        // Break equilibrium to force node views to relayout
        for nodeId in nodesUpdate.addedIds {
            let angle = CGFloat.random(in: 0...(2 * .pi))
            let factor: CGFloat = 10
            nodeSKNodes[nodeId]?.physicsBody?.applyImpulse(.init(dx: factor * cos(angle), dy: factor * sin(angle)))
        }
        
        // Sync the edge views
        edgesParent.diffUpdate(nodes: &edgeSKNodes, with: model.edges, id: \.self) { _, edge in
            let srcSKNode = nodeSKNodes[edge.srcId]!
            let destSKNode = nodeSKNodes[edge.destId]!
            return SynthesizerEdgeSKNode(
                srcSKNode: srcSKNode,
                destSKNode: destSKNode
            )
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
            let srcNode = nodeSKNodes[edge.srcId]!
            let destNode = nodeSKNodes[edge.destId]!
            return joint(from: srcNode, to: destNode)
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
        for (edge, edgeNode) in edgeSKNodes {
            (edgeNode as? SynthesizerEdgeSKNode)?.update()
            // Uncomment to enable attractive forces between edges as an alternative to joints:
            // if let srcNode = nodeNodes[edge.srcId],
            //   let destNode = nodeNodes[edge.destId] {
            //    let factor: CGFloat = 0.5
            //    let force = (destNode.position - srcNode.position).map { factor * $0 }
            //    srcNode.physicsBody!.applyForce(force)
            //    destNode.physicsBody!.applyForce(-force)
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
