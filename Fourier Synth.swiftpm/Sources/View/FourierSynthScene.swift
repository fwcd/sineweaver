//
//  FourierSynthSwiftUI.swift
//  Fourier Synth
//
//  Created on 24.11.24
//

import Combine
import SpriteKit

final class FourierSynthScene: SKScene {
    private let synthesizer: Synthesizer
    
    private let synthesizerView: SynthesizerView
    private var synthesizerSubscription: AnyCancellable?
    
    init(synthesizer: Synthesizer) {
        print("(Re)creating scene")
        
        self.synthesizer = synthesizer
        
        synthesizerView = .init(synthesizer: synthesizer)
        
        // TODO: Figure out sizing
        super.init(size: CGSize(width: 640, height: 480))
        
        scaleMode = .aspectFill
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        addChild(synthesizerView)
        
        // TODO: Make this user-editable instead of setting up demo graph
        do {
            synthesizer.model.lock().wrappedValue.useValue { model in
                let sineId = model.add(node: .sine(.init()))
                let mixerId = model.add(node: .mixer(.init()))
                model.connect(sineId, to: mixerId)
            }
        }
        
        synthesizerSubscription = synthesizer.objectWillChange.sink { [unowned self] in
            synthesizerView.sync()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        nil
    }
    
    private func sync() {
        synthesizerView.sync()
    }
}
