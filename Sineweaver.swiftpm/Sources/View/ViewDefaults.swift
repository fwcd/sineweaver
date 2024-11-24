import SpriteKit
import SwiftUI

/// Default configurations for UI elements.
public enum ViewDefaults {
    // MARK: General
    
    public static let fontName: String = "Helvetica"
    public static let fontSize: CGFloat = 14
    public static let titleFontSize: CGFloat = 36
    public static let headerFontSize: CGFloat = 18
    public static let padding: CGFloat = 10
    public static let symbolSize: CGFloat = 2 * fontSize
    public static let textFieldHeight: CGFloat = 24
    public static let textFieldFontSize: CGFloat = 18
    public static let sliderKnobRadius: CGFloat = 10
    public static let sliderTrackThickness: CGFloat = 5
    public static let smallButtonSize: CGFloat = 14
    public static let cornerRadius: CGFloat = 5

    // MARK: Color scheme
    
    public static let primary: UIColor = .white
    public static let secondary: UIColor = UIColor(white: 1, alpha: 0.5)
    public static let tertiary: UIColor = UIColor(white: 1, alpha: 0.2)
    public static let quaternary: UIColor = UIColor(white: 1, alpha: 0.1)
    public static let background: UIColor = UIColor(white: 0.15, alpha: 1)
    public static let translucentBackground: UIColor = background.withAlphaComponent(0.5)
    public static let transparent: UIColor = UIColor(white: 0, alpha: 0)
    public static let inactiveBgColor: UIColor = tertiary
    public static let activeBgColor: UIColor = quaternary
    public static let knobInactiveBgColor: UIColor = primary
    public static let knobActiveBgColor: UIColor = secondary
    public static let formLabelFontColor: UIColor = secondary
}
