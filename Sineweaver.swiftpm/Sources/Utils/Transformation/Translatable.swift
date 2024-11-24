import Foundation
import CoreGraphics

protocol Translatable {
    associatedtype Offset
    
    static func +(lhs: Self, offset: Offset) -> Self
    
    static func -(lhs: Self, offset: Offset) -> Self
}

extension Int: Translatable {
    typealias Offset = Int
}

extension Double: Translatable {
    typealias Offset = Double
}

extension CGFloat: Translatable {
    typealias Offset = CGFloat
}

extension CGPoint: Translatable {
    typealias Offset = CGVector
}
