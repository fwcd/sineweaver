//
//  SynthesizerNode.swift
//  Sineweaver
//
//  Created on 22.11.24
//

/// A processing node.
enum SynthesizerNode: SynthesizerNodeProtocol {
    case oscillator(OscillatorNode)
    case mixer(MixerNode)
    case silence(SilenceNode)
    
    var type: SynthesizerNodeType {
        switch self {
        case .oscillator: .oscillator
        case .mixer: .mixer
        case .silence: .silence
        }
    }
    
    var name: String {
        type.name
    }
    
    var asOscillator: OscillatorNode {
        get {
            switch self {
            case .oscillator(let node): node
            default: .init()
            }
        }
        set {
            self = .oscillator(newValue)
        }
    }
    
    var asMixer: MixerNode {
        get {
            switch self {
            case .mixer(let node): node
            default: .init()
            }
        }
        set {
            self = .mixer(newValue)
        }
    }
    
    var asSilence: SilenceNode {
        get {
            switch self {
            case .silence(let node): node
            default: .init()
            }
        }
        set {
            self = .silence(newValue)
        }
    }
    
    init(type: SynthesizerNodeType) {
        switch type {
        case .oscillator: self = .oscillator(.init())
        case .mixer: self = .mixer(.init())
        case .silence: self = .silence(.init())
        }
    }
    
    mutating func render(inputs: [[Double]], output: inout [Double], context: SynthesizerContext) {
        switch self {
        case .oscillator: asOscillator.render(inputs: inputs, output: &output, context: context)
        case .mixer: asMixer.render(inputs: inputs, output: &output, context: context)
        case .silence: asSilence.render(inputs: inputs, output: &output, context: context)
        }
    }
}
