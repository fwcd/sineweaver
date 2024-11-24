import Foundation
import SpriteKit

/// A simple UI control that displays a label and performs an action when clicked.
final class ButtonNode: SKSpriteNode, SceneInputHandler {
    private var controllerSubscription: Subscription!
    
    let label: SKNode
    private let inactiveBgColor: UIColor
    private let activeBgColor: UIColor
    private let padding: CGFloat
    private let action: ((ButtonNode) -> Void)?
    
    /// A toggle state that overrides the usual input handling.
    var isToggled: Bool? {
        didSet {
            color = (isToggled ?? false) ? activeBgColor : inactiveBgColor
        }
    }
    
    init(
        controller: GenericDragController,
        label: SKNode,
        size: CGSize,
        padding: CGFloat = ViewDefaults.padding,
        inactiveBgColor: UIColor = ViewDefaults.inactiveBgColor,
        activeBgColor: UIColor = ViewDefaults.activeBgColor,
        action: ((ButtonNode) -> Void)? = nil
    ) {
        self.label = label
        self.inactiveBgColor = inactiveBgColor
        self.activeBgColor = activeBgColor
        self.padding = padding
        self.action = action
        
        super.init(texture: nil, color: inactiveBgColor, size: CGSize(width: size.width + padding, height: size.height + padding))
        controllerSubscription = controller.register(node: self)
        
        addChild(label)
    }
    
    /// Creates a textual button.
    convenience init(
        controller: GenericDragController,
        _ text: String,
        width: CGFloat? = nil,
        height: CGFloat? = nil,
        fontSize: CGFloat = ViewDefaults.fontSize,
        fontName: String = ViewDefaults.fontName,
        action: ((ButtonNode) -> Void)? = nil
    ) {
        let label = LabelNode(text, fontSize: fontSize, fontName: fontName)
        let frameSize = label.frame.size
        let size = CGSize(width: width ?? frameSize.width, height: height ?? frameSize.height)
        self.init(controller: controller, label: label, size: size, action: action)
    }
    
    /// Creates a textural button.
    convenience init(
        controller: GenericDragController,
        iconTexture: SKTexture,
        size: CGFloat = ViewDefaults.fontSize,
        action: ((ButtonNode) -> Void)? = nil
    ) {
        let size = CGSize(width: size, height: size)
        let label = SKSpriteNode(texture: iconTexture, size: size)
        self.init(controller: controller, label: label, size: size, action: action)
    }
    
    required init?(coder aDecoder: NSCoder) {
        nil
    }
    
    private func active(at point: CGPoint) -> Bool {
        parent.map { contains(convert(point, to: $0)) } ?? false
    }
    
    func inputDown(at point: CGPoint) {
        if isToggled == nil {
            color = activeBgColor
        }
    }
    
    func inputDragged(to point: CGPoint) {
        if isToggled == nil {
            color = active(at: point) ? activeBgColor : inactiveBgColor
        }
    }
    
    func inputUp(at point: CGPoint) {
        color = inactiveBgColor
        if active(at: point) {
            action?(self)
        }
    }
}
