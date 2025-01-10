//
//  Edge+Either.swift
//  Sineweaver
//
//  Created on 10.01.25
//

import SwiftUI

extension Edge {
    var asEither: Either<HorizontalEdge, VerticalEdge> {
        switch self {
        case .leading: .left(.leading)
        case .trailing: .left(.trailing)
        case .top: .right(.top)
        case .bottom: .right(.bottom)
        }
    }
}
