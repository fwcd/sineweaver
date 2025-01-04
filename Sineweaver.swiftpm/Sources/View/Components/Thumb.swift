//
//  Thumb.swift
//  Sineweaver
//
//  Created on 27.12.24
//

import SwiftUI

struct Thumb: View {
    var size: CGFloat = 20
    
    var body: some View {
        Circle()
            .frame(width: size, height: size)
    }
}
