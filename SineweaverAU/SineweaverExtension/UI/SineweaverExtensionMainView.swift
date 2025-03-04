//
//  SineweaverExtensionMainView.swift
//  Sineweaver
//
//  Created on 04.03.25
//

import SwiftUI

struct SineweaverExtensionMainView: View {
    let synthesizer: SynthesizerViewModel
    
    var body: some View {
        SynthesizerChapterView(chapter: nil)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .safeAreaInset(edge: .bottom) {
                HStack {
                    SynthesizerToolbar()
                }
            }
            .environmentObject(synthesizer)
    }
}
