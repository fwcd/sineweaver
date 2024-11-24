//
//  SKTexture+Extensions.swift
//  Sineweaver
//
//  Created on 24.11.24
//

import SpriteKit

extension SKTexture {
    // See https://stackoverflow.com/a/78499817
    
    convenience init?(systemName: String, pointSize: CGFloat) {
        let config = UIImage.SymbolConfiguration(pointSize: pointSize)
        guard let symbol = UIImage(systemName: systemName)?.applyingSymbolConfiguration(config) else { return nil }

        let rect = CGRect(origin: .zero, size: symbol.size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)

        UIColor.white.setFill()
        UIRectFill(rect)

        let ctx = UIGraphicsGetCurrentContext()
        ctx?.setBlendMode(.destinationIn)
        ctx?.draw(symbol.cgImage!, in: rect)

        let result = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        self.init(image: result)
    }
}
