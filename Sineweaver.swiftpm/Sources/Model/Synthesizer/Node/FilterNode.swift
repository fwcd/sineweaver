//
//  FilterNode.swift
//  Sineweaver
//
//  Created on 07.01.25
//

/// A low/high-pass filter, internally implemented as a windowed-sinc (FIR) filter.
///
/// For details on the implementation, see `Utils/DSP/Filters.swift`.
struct FilterNode: SynthesizerNodeProtocol {
    var filter: Filter = .init()
    
    struct Filter: Hashable, Codable {
        var kind: Kind = .lowpass
        var cutoffHz: Double = 200
        var transitionBandwidthHz: Double = 1000 // TODO: Should this be dependent on the cutoff? Is there an easy way to e.g. specify this as dB/octave and compute the bandwidth in Hz from that?
        
        enum Kind: Hashable, Codable, CaseIterable {
            case lowpass
            case highpass
        }
    }
    
    struct State {
        let params: Filter
        let sampleRate: Double
        let coefficients: [Double]
        var buffer: CyclicBuffer<Double>
        
        init(params: Filter, sampleRate: Double = 10, oldBuffer: CyclicBuffer<Double>? = nil) {
            self.params = params
            self.sampleRate = sampleRate
            
            switch params.kind {
            case .lowpass:
                coefficients = makeLowpassFilter(
                    sampleRate: sampleRate,
                    cutoffHz: params.cutoffHz,
                    transitionBandwidthHz: params.transitionBandwidthHz
                )
            case .highpass:
                coefficients = makeHighpassFilter(
                    sampleRate: sampleRate,
                    cutoffHz: params.cutoffHz,
                    transitionBandwidthHz: params.transitionBandwidthHz
                )
            }
            
            buffer = .zeros(size: coefficients.count)
            if let oldBuffer {
                buffer += oldBuffer
            }
        }
        
        mutating func filter(_ sample: Double) -> Double {
            buffer.append(sample)
            
            var filtered: Double = 0
            for (coefficient, sample) in zip(coefficients, buffer) {
                filtered += coefficient * sample
            }
            
            return filtered
        }
    }
    
    func makeState() -> State {
        State(params: filter)
    }

    func render(inputs: [SynthesizerNodeInput], output: inout [Double], state: inout State, context: SynthesizerContext) -> Bool {
        guard let input = inputs.first else { return false }
        
        // Recompute filter if needed
        if state.params != filter || state.sampleRate != context.sampleRate {
            state = State(params: filter, sampleRate: context.sampleRate, oldBuffer: state.buffer)
        }
        
        for i in 0..<output.count {
            output[i] = state.filter(input.buffer[i])
        }
        
        return input.isActive
    }
}
