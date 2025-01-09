//
//  FrameReader.swift
//  Sineweaver
//
//  Created on 09.01.25
//

import SwiftUI

struct FrameReader<CoordinateSpace>: View where CoordinateSpace: CoordinateSpaceProtocol {
    private let coordinateSpace: CoordinateSpace
    private let onFrame: (CGRect?) -> Void
    
    var body: some View {
        GeometryReader { proxy in
            let frame = proxy.frame(in: coordinateSpace)
            Color.clear
                .onAppear {
                    onFrame(frame)
                }
                .onChange(of: frame) {
                    onFrame(frame)
                }
                .onDisappear {
                    onFrame(nil)
                }
        }
    }
    
    init(in coordinateSpace: CoordinateSpace, onFrame: @escaping (CGRect?) -> Void) {
        self.coordinateSpace = coordinateSpace
        self.onFrame = onFrame
    }
}
