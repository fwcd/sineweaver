//
//  IconNode.swift
//  Sineweaver
//
//  Created on 24.11.24
//

import SpriteKit
import UIKit

final class IconNode: SKSpriteNode {
    convenience init(
        systemName: String,
        pointSize: CGFloat = ViewDefaults.symbolSize,
        color: UIColor = ViewDefaults.primary
    ) {
        self.init(texture: SKTexture(systemName: systemName, pointSize: pointSize))
        self.color = color
        colorBlendFactor = 1
    }
}
