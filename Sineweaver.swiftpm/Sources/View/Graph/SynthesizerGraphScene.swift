//
//  SynthesizerGraphScene.swift
//  Sineweaver
//
//  Created on 24.11.24
//

import Combine
import SpriteKit

final class SynthesizerGraphScene: SKScene, SceneInputHandler {
    private let synthesizer: Synthesizer
    
    private let synthesizerView: SynthesizerGraphSKNode
    
    private var genericDrags: GenericDragController!
    private var dragState: DragState = .inactive
    
    private enum DragState {
        case generic
        case synthesizer
        case inactive
    }
    
    init(synthesizer: Synthesizer) {
        print("(Re)creating scene")
        
        self.synthesizer = synthesizer
        
        synthesizerView = .init(synthesizer: synthesizer)
        
        // TODO: Figure out sizing
        super.init(size: CGSize(width: 1000, height: 800))
        
        genericDrags = GenericDragController(parent: self)
        
        scaleMode = .aspectFill
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        addChild(synthesizerView)
        
        synthesizer.$model.lock().onChange { [unowned self] in
            Task { @MainActor in
                sync()
            }
        }
        
        // TODO: Make this user-editable instead of setting up demo graph
        do {
            synthesizer.$model.lock().useValue { model in
                let sineId = model.add(node: .oscillator(.init()))
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
    
    func inputDown(at point: CGPoint) {
        if genericDrags.handleInputDown(at: point) {
            dragState = .generic
        } else {
            synthesizerView.inputDown(at: convert(point, to: synthesizerView))
            dragState = .synthesizer
        }
    }
    
    func inputDragged(to point: CGPoint) {
        switch dragState {
        case .generic:
            genericDrags.handleInputDragged(to: point)
        case .synthesizer:
            synthesizerView.inputDragged(to: convert(point, to: synthesizerView))
        case .inactive:
            break
        }
    }
    
    func inputUp(at point: CGPoint) {
        switch dragState {
        case .generic:
            genericDrags.handleInputUp(at: point)
        case .synthesizer:
            synthesizerView.inputUp(at: convert(point, to: synthesizerView))
        case .inactive:
            break
        }
    }
}
