import SpriteKit

extension SKPhysicsWorld: DiffUpdatable {
    func addChildForDiffUpdate(_ joint: SKPhysicsJoint) {
        add(joint)
    }
    
    func removeChildForDiffUpdate(_ joint: SKPhysicsJoint) {
        remove(joint)
    }
}
