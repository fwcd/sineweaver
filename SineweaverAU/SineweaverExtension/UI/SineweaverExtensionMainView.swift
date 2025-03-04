//
//  SineweaverExtensionMainView.swift
//  Sineweaver
//
//  Created on 04.03.25
//

import SwiftUI

struct SineweaverExtensionMainView: View {
    var parameterTree: ObservableAUParameterGroup
    
    var body: some View {
        ParameterSlider(param: parameterTree.global.gain)
    }
}
