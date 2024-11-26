import SpriteKit

extension SKNode {
    func move(dx: CGFloat, dy: CGFloat) {
        position = CGPoint(x: position.x + dx, y: position.y + dy)
    }
    
    /// The top-left position of the accumulated frame in the parent's coordinate space.
    var topLeftPosition: CGPoint {
        get {
            let frame = calculateAccumulatedFrame()
            return CGPoint(x: frame.minX, y: frame.maxY)
        }
        set {
            let oldValue = topLeftPosition
            move(dx: newValue.x - oldValue.x, dy: newValue.y - oldValue.y)
        }
    }
    /// The top-center position of the accumulated frame in the parent's coordinate space.
    var topCenterPosition: CGPoint {
        get {
            let frame = calculateAccumulatedFrame()
            return CGPoint(x: frame.midX, y: frame.maxY)
        }
        set {
            let oldValue = topCenterPosition
            move(dx: newValue.x - oldValue.x, dy: newValue.y - oldValue.y)
        }
    }
    /// The top-right position of the accumulated frame in the parent's coordinate space.
    var topRightPosition: CGPoint {
        get {
            let frame = calculateAccumulatedFrame()
            return CGPoint(x: frame.maxX, y: frame.maxY)
        }
        set {
            let oldValue = topRightPosition
            move(dx: newValue.x - oldValue.x, dy: newValue.y - oldValue.y)
        }
    }
    /// The bottom-left position of the accumulated frame in the parent's coordinate space.
    var bottomLeftPosition: CGPoint {
        get {
            let frame = calculateAccumulatedFrame()
            return CGPoint(x: frame.minX, y: frame.minY)
        }
        set {
            let oldValue = bottomLeftPosition
            move(dx: newValue.x - oldValue.x, dy: newValue.y - oldValue.y)
        }
    }
    /// The bottom-center position of the accumulated frame in the parent's coordinate space.
    var bottomCenterPosition: CGPoint {
        get {
            let frame = calculateAccumulatedFrame()
            return CGPoint(x: frame.midX, y: frame.minY)
        }
        set {
            let oldValue = bottomCenterPosition
            move(dx: newValue.x - oldValue.x, dy: newValue.y - oldValue.y)
        }
    }
    /// The bottom-right position of the accumulated frame in the parent's coordinate space.
    var bottomRightPosition: CGPoint {
        get {
            let frame = calculateAccumulatedFrame()
            return CGPoint(x: frame.maxX, y: frame.minY)
        }
        set {
            let oldValue = bottomRightPosition
            move(dx: newValue.x - oldValue.x, dy: newValue.y - oldValue.y)
        }
    }
    /// The center-left position of the accumulated frame in the parent's coordinate space.
    var centerLeftPosition: CGPoint {
        get {
            let frame = calculateAccumulatedFrame()
            return CGPoint(x: frame.minX, y: frame.midY)
        }
        set {
            let oldValue = centerLeftPosition
            move(dx: newValue.x - oldValue.x, dy: newValue.y - oldValue.y)
        }
    }
    /// The center position of the accumulated frame in the parent's coordinate space.
    var centerPosition: CGPoint {
        get {
            let frame = calculateAccumulatedFrame()
            return CGPoint(x: frame.midX, y: frame.midY)
        }
        set {
            let oldValue = centerPosition
            move(dx: newValue.x - oldValue.x, dy: newValue.y - oldValue.y)
        }
    }
    /// The center-right position of the accumulated frame in the parent's coordinate space.
    var centerRightPosition: CGPoint {
        get {
            let frame = calculateAccumulatedFrame()
            return CGPoint(x: frame.maxX, y: frame.midY)
        }
        set {
            let oldValue = centerRightPosition
            move(dx: newValue.x - oldValue.x, dy: newValue.y - oldValue.y)
        }
    }
    
    subscript(cornerPosition corner: Corner) -> CGPoint {
        get {
            switch corner {
            case .topLeft: return topLeftPosition
            case .topCenter: return topCenterPosition
            case .topRight: return topRightPosition
            case .centerLeft: return centerLeftPosition
            case .centerRight: return centerRightPosition
            case .bottomLeft: return bottomLeftPosition
            case .bottomCenter: return bottomCenterPosition
            case .bottomRight: return bottomRightPosition
            }
        }
        set {
            switch corner {
            case .topLeft: topLeftPosition = newValue
            case .topCenter: topCenterPosition = newValue
            case .topRight: topRightPosition = newValue
            case .centerLeft: centerLeftPosition = newValue
            case .centerRight: centerRightPosition = newValue
            case .bottomLeft: bottomLeftPosition = newValue
            case .bottomCenter: bottomCenterPosition = newValue
            case .bottomRight: bottomRightPosition = newValue
            }
        }
    }
    
    func setVisibility(of child: SKNode, to shouldBeVisible: Bool) {
        let isVisible = child.parent != nil
        if isVisible != shouldBeVisible {
            if shouldBeVisible {
                addChild(child)
            } else {
                child.removeFromParent()
            }
        }
    }
}
