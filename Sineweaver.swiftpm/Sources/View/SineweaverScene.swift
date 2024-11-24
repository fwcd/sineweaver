//
//  SineweaverSwiftUI.swift
//  Sineweaver
//
//  Created on 24.11.24
//

import Combine
import SpriteKit

final class SineweaverScene: SKScene {
    private let synthesizer: Synthesizer
    
    private let synthesizerView: SynthesizerView
    private var synthesizerSubscription: AnyCancellable?
    
    override init() {
        print("(Re)creating scene")
        
        synthesizer = try! .init()
        synthesizerView = .init(synthesizer: synthesizer)
        
        // TODO: Figure out sizing
        super.init(size: CGSize(width: 1000, height: 800))
        
        scaleMode = .aspectFill
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        addChild(synthesizerView)
        
        synthesizerSubscription = synthesizer.objectWillChange.sink { [unowned self] in
            sync()
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
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        synthesizerView.children[0].position = touch.location(in: self)
    }
}
