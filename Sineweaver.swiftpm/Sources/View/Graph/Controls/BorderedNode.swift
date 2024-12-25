import Foundation
import SpriteKit

/// A simple layout container that aligns elements at leading, centered and trailing positions.
final class BorderedNode: SKNode {
    init(
        _ axis: StackNode.Direction,
        length: CGFloat,
        padding: CGFloat = ViewDefaults.padding,
        leading: [SKNode] = [],
        centered: [SKNode] = [],
        trailing: [SKNode] = []
    ) {
        super.init()
        
        let leadingStack = StackNode(axis, children: leading)
        let centeredStack = StackNode(axis, children: centered)
        let trailingStack = StackNode(axis, children: trailing)
        
        switch axis {
        case .horizontal:
            leadingStack.centerLeftPosition = CGPoint(x: -(length / 2) + padding, y: 0)
            trailingStack.centerRightPosition = CGPoint(x: (length / 2) - padding, y: 0)
        case .vertical:
            leadingStack.topCenterPosition = CGPoint(x: 0, y: (length / 2) - padding)
            trailingStack.bottomCenterPosition = CGPoint(x: 0, y: -(length / 2) + padding)
        }
        
        centeredStack.centerPosition = CGPoint(x: 0, y: 0)
        
        addChild(leadingStack)
        addChild(centeredStack)
        addChild(trailingStack)
    }
    
    required init?(coder aDecoder: NSCoder) {
        nil
    }
}
