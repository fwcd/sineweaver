//
//  SynthesizerLFOView.swift
//  Sineweaver
//
//  Created on 25.12.24
//

import SwiftUI

struct SynthesizerLFOView<Node>: View where Node: SynthesizerNodeProtocol {
    let node: Node
    
    var body: some View {
        SynthesizerChartView(node: node, animated: true)
    }
}

#Preview {
    SynthesizerLFOView(node: OscillatorNode(frequency: 0.5))
}
