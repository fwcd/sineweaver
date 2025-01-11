//
//  OctavePicker.swift
//  Sineweaver
//
//  Created on 11.01.25
//

import SwiftUI

struct OctavePicker: View {
    let noteClass: NoteClass
    @Binding var octave: Int
    
    var body: some View {
        Stepper("Octave: \(noteClass)\(octave)", value: $octave, in: 0...9)
            .monospacedDigit()
            .fixedSize()
    }
}
