//
//  Thumb.swift
//  Sineweaver
//
//  Created on 27.12.24
//

import SwiftUI

struct Thumb: View {
    var isEnabled: Bool = true
    var size: CGFloat = 20
    
    var body: some View {
        Circle()
            .strokeBorder(.foreground, lineWidth: isEnabled ? 0 : 2)
            .fill(isEnabled ? AnyShapeStyle(.foreground) : AnyShapeStyle(.clear))
            .frame(width: size, height: size)
    }
}

#Preview {
    VStack {
        Thumb(isEnabled: true)
        Thumb(isEnabled: false)
    }
}
