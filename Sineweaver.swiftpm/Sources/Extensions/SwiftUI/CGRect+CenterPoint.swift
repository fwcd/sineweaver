//
//  CGRect+CenterPoint.swift
//  Sineweaver
//
//  Created on 13.01.25
//

import SwiftUI

extension CGRect {
    func centerPoint(of edge: Edge? = nil) -> CGPoint {
        switch edge {
        case .top: .init(x: midX, y: minY)
        case .leading: .init(x: minX, y: midY)
        case .bottom: .init(x: midX, y: maxY)
        case .trailing: .init(x: maxX, y: midY)
        case nil: .init(x: midX, y: midY)
        }
    }
}
