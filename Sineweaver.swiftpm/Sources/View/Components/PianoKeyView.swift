//
//  PianoKeyView.swift
//  Sineweaver
//
//  Created on 04.01.25
//

import SwiftUI

struct PianoKeyView: View {
    let note: Note
    let size: CGSize
    let pressed: Bool
    let enabled: Bool
    let hasLabel: Bool
    
    var body: some View {
        Rectangle()
            .fill(
                pressed
                    ? Color.gray
                    : note.accidental.isUnaltered
                        ? Color.white
                        : Color.black
            )
            .strokeBorder(note.accidental.isUnaltered ? Color.gray : .clear)
            .frame(width: size.width, height: size.height)
            .opacity(enabled ? 1 : 0.7)
            .overlay(alignment: .bottom) {
                if hasLabel {
                    Text("\(note)")
                        .font(.system(size: size.width * 0.45))
                        .foregroundStyle(.black.opacity(0.5))
                        .padding(.bottom, 2)
                }
            }
    }
}
