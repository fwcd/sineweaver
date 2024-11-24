//
//  Corner.swift
//  Sineweaver
//
//  Created on 24.11.24
//

import SpriteKit

enum Corner: CaseIterable, Hashable {
    case topLeft
    case topCenter
    case topRight
    case centerLeft
    case centerRight
    case bottomLeft
    case bottomCenter
    case bottomRight
    
    /// A normalized vector that points 'outwards' from the given position.
    var direction: CGVector {
        let invSqrt2 = 1 / sqrt(2)
        switch self {
        case .topLeft:
            return CGVector(dx: -invSqrt2, dy: invSqrt2)
        case .topCenter:
            return CGVector(dx: 0, dy: 1)
        case .topRight:
            return CGVector(dx: invSqrt2, dy: invSqrt2)
        case .centerLeft:
            return CGVector(dx: -1, dy: 0)
        case .centerRight:
            return CGVector(dx: 1, dy: 0)
        case .bottomLeft:
            return CGVector(dx: -invSqrt2, dy: -invSqrt2)
        case .bottomCenter:
            return CGVector(dx: 0, dy: -1)
        case .bottomRight:
            return CGVector(dx: invSqrt2, dy: -invSqrt2)
        }
    }
}
