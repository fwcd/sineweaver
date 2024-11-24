//
//  SineweaverSwiftUI.swift
//  Sineweaver
//
//  Created on 24.11.24
//

import Combine
import SpriteKit

final class SineweaverScene: SKScene, SceneInputHandler {
    private let synthesizer: Synthesizer
    
    private let synthesizerView: SynthesizerView
    
    init(synthesizer: Synthesizer) {
        print("(Re)creating scene")
        
        self.synthesizer = synthesizer
        synthesizerView = .init(synthesizer: synthesizer)
        
        // TODO: Figure out sizing
        super.init(size: CGSize(width: 1000, height: 800))
        
        scaleMode = .aspectFill
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        addChild(synthesizerView)
        
        synthesizer.model.lock().onChange { [unowned self] in
            Task { @MainActor in
                sync()
            }
        }
        
        // TODO: Make this user-editable instead of setting up demo graph
        do {
            synthesizer.model.lock().useValue { model in
                let sineId = model.add(node: .sine(.init()))
                let mixerId = model.add(node: .mixer(.init()))
                model.connect(sineId, to: mixerId)
                model.outputNodeId = mixerId
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        nil
    }
    
    private func sync() {
        synthesizerView.sync(parentScene: self)
    }
    
    override func update(_ currentTime: TimeInterval) {
        synthesizerView.update()
    }
    
    // FIXME: Remove this
    func inputDragged(to point: CGPoint) {
        synthesizerView.children[0].children[0].position = point
    }
}
