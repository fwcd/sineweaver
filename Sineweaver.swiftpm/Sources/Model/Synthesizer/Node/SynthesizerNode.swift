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
    case lfo(LFONode)
    case noise(NoiseNode)
    case filter(FilterNode)
    case mixer(MixerNode)
    case silence(SilenceNode)
    case wavExport(WavExportNode)
    case envelope(EnvelopeNode)
    case activeGate(ActiveGateNode)
    case controller(ControllerNode)
    
    var type: SynthesizerNodeType {
        switch self {
        case .oscillator: .oscillator
        case .lfo: .lfo
        case .noise: .noise
        case .filter: .filter
        case .mixer: .mixer
        case .silence: .silence
        case .wavExport: .wavExport
        case .envelope: .envelope
        case .activeGate: .activeGate
        case .controller: .controller
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
    
    var asLFO: LFONode {
        get {
            switch self {
            case .lfo(let node): node
            default: .init()
            }
        }
        set {
            self = .lfo(newValue)
        }
    }
    
    var asNoise: NoiseNode {
        get {
            switch self {
            case .noise(let node): node
            default: .init()
            }
        }
        set {
            self = .noise(newValue)
        }
    }
    
    var asFilter: FilterNode {
        get {
            switch self {
            case .filter(let node): node
            default: .init()
            }
        }
        set {
            self = .filter(newValue)
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
    
    var asActiveGate: ActiveGateNode {
        get {
            switch self {
            case .activeGate(let node): node
            default: .init()
            }
        }
        set {
            self = .activeGate(newValue)
        }
    }
    
    var asController: ControllerNode {
        get {
            switch self {
            case .controller(let node): node
            default: .init()
            }
        }
        set {
            self = .controller(newValue)
        }
    }
    
    var isActive: Bool {
        switch self {
        case .oscillator(let node): node.isPlaying
        case .controller(let node): node.isActive
        default: false
        }
    }
    
    init(type: SynthesizerNodeType) {
        switch type {
        case .oscillator: self = .oscillator(.init())
        case .lfo: self = .lfo(.init())
        case .noise: self = .noise(.init())
        case .filter: self = .filter(.init())
        case .mixer: self = .mixer(.init())
        case .silence: self = .silence(.init())
        case .wavExport: self = .wavExport(.init())
        case .envelope: self = .envelope(.init())
        case .activeGate: self = .activeGate(.init())
        case .controller: self = .controller(.init())
        }
    }
    
    func makeState() -> State {
        switch self {
        case .oscillator(let node): node.makeState()
        case .lfo(let node): node.makeState()
        case .noise(let node): node.makeState()
        case .filter(let node): node.makeState()
        case .mixer(let node): node.makeState()
        case .silence(let node): node.makeState()
        case .wavExport(let node): node.makeState()
        case .envelope(let node): node.makeState()
        case .activeGate(let node): node.makeState()
        case .controller(let node): node.makeState()
        }
    }
    
    func render(inputs: [SynthesizerNodeInput], output: inout [Double], state: inout State, context: SynthesizerContext) -> Bool {
        switch self {
        case .oscillator(let node):
            var oscState: OscillatorNode.State = state as! OscillatorNode.State
            defer { state = oscState }
            return node.render(inputs: inputs, output: &output, state: &oscState, context: context)
        case .lfo(let node):
            var lfoState: LFONode.State = state as! LFONode.State
            defer { state = lfoState }
            return node.render(inputs: inputs, output: &output, state: &lfoState, context: context)
        case .noise(let node):
            var noiseState: NoiseNode.State = state as! NoiseNode.State
            defer { state = noiseState }
            return node.render(inputs: inputs, output: &output, state: &noiseState, context: context)
        case .filter(let node):
            var filterState: FilterNode.State = state as! FilterNode.State
            defer { state = filterState }
            return node.render(inputs: inputs, output: &output, state: &filterState, context: context)
        case .mixer(let node):
            var mixerState: MixerNode.State = state as! MixerNode.State
            defer { state = mixerState }
            return node.render(inputs: inputs, output: &output, state: &mixerState, context: context)
        case .silence(let node):
            var silenceState: SilenceNode.State = state as! SilenceNode.State
            defer { state = silenceState }
            return node.render(inputs: inputs, output: &output, state: &silenceState, context: context)
        case .wavExport(let node):
            var wavState: WavExportNode.State = state as! WavExportNode.State
            defer { state = wavState }
            return node.render(inputs: inputs, output: &output, state: &wavState, context: context)
        case .envelope(let node):
            var envState: EnvelopeNode.State = state as! EnvelopeNode.State
            defer { state = envState }
            return node.render(inputs: inputs, output: &output, state: &envState, context: context)
        case .activeGate(let node):
            var gateState: ActiveGateNode.State = state as! ActiveGateNode.State
            defer { state = gateState }
            return node.render(inputs: inputs, output: &output, state: &gateState, context: context)
        case .controller(let node):
            var controllerState: ControllerNode.State = state as! ControllerNode.State
            defer { state = controllerState }
            return node.render(inputs: inputs, output: &output, state: &controllerState, context: context)
        }
    }
}
