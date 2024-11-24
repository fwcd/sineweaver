import Foundation
import SpriteKit

/// A textual UI element. Wraps SKLabelNode by positioning it in a way
/// that interacts better with Button.
final class LabelNode: SKLabelNode {
    convenience init(
        _ text: String,
        fontSize: CGFloat = ViewDefaults.fontSize,
        fontName: String = ViewDefaults.fontName,
        fontColor: UIColor = ViewDefaults.primary
    ) {
        self.init(text: text)
        self.fontSize = fontSize
        self.fontName = fontName
        self.fontColor = fontColor
        verticalAlignmentMode = .center
    }
}
