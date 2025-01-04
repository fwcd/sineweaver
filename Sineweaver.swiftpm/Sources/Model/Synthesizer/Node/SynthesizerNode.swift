//
//  SynthesizerNode.swift
//  Sineweaver
//
//  Created on 22.11.24
//

/// A processing node.
enum SynthesizerNode: SynthesizerNodeProtocol {
    typealias State = any Sendable
    
    case oscillator(OscillatorNode)
    case mixer(MixerNode)
    case silence(SilenceNode)
    case wavExport(WavExportNode)
    case envelope(EnvelopeNode)
    
    var type: SynthesizerNodeType {
        switch self {
        case .oscillator: .oscillator
        case .mixer: .mixer
        case .silence: .silence
        case .wavExport: .wavExport
        case .envelope: .envelope
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
    
    var asWavExport: WavExportNode {
        get {
            switch self {
            case .wavExport(let node): node
            default: .init()
            }
        }
        set {
            self = .wavExport(newValue)
        }
    }
    
    var asEnvelope: EnvelopeNode {
        get {
            switch self {
            case .envelope(let node): node
            default: .init()
            }
        }
        set {
            self = .envelope(newValue)
        }
    }
    
    init(type: SynthesizerNodeType) {
        switch type {
        case .oscillator: self = .oscillator(.init())
        case .mixer: self = .mixer(.init())
        case .silence: self = .silence(.init())
        case .wavExport: self = .wavExport(.init())
        case .envelope: self = .envelope(.init())
        }
    }
    
    func makeState() -> State {
        switch self {
        case .oscillator(let node): node.makeState()
        case .mixer(let node): node.makeState()
        case .silence(let node): node.makeState()
        case .wavExport(let node): node.makeState()
        case .envelope(let node): node.makeState()
        }
    }
    
    func render(inputs: [[Double]], output: inout [Double], state: inout State, context: SynthesizerContext) {
        switch self {
        case .oscillator(let node):
            var oscState: OscillatorNode.State = state as! OscillatorNode.State
            node.render(inputs: inputs, output: &output, state: &oscState, context: context)
            state = oscState
        case .mixer(let node):
            var mixerState: MixerNode.State = state as! MixerNode.State
            node.render(inputs: inputs, output: &output, state: &mixerState, context: context)
            state = mixerState
        case .silence(let node):
            var silenceState: SilenceNode.State = state as! SilenceNode.State
            node.render(inputs: inputs, output: &output, state: &silenceState, context: context)
            state = silenceState
        case .wavExport(let node):
            var wavState: WavExportNode.State = state as! WavExportNode.State
            node.render(inputs: inputs, output: &output, state: &wavState, context: context)
            state = wavState
        case .envelope(let node):
            var envState: EnvelopeNode.State = state as! EnvelopeNode.State
            node.render(inputs: inputs, output: &output, state: &envState, context: context)
            state = envState
        }
    }
}
