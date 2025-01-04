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
    }
}
