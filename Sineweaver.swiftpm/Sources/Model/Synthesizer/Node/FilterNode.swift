//
//  FilterNode.swift
//  Sineweaver
//
//  Created on 07.01.25
//

import Foundation

/// A low/high-pass filter, internally implemented as a windowed-sinc (FIR) filter.
///
/// For details on the implementation, see `Utils/DSP/Filters.swift`.
struct FilterNode: SynthesizerNodeProtocol {
    var filter: Filter = .init()
    var modulationFactor: Double = 0.5
    
    struct Filter: Hashable, Codable {
        var kind: Kind = .lowpass
        var cutoffHz: Double = 1000
        var transitionBandwidthHz: Double = 1000 // TODO: Should this be dependent on the cutoff? Is there an easy way to e.g. specify this as dB/octave and compute the bandwidth in Hz from that?
        
        enum Kind: String, Hashable, Codable, CaseIterable, CustomStringConvertible {
            case lowpass = "Low-Pass"
            case highpass = "High-Pass"
            
            var description: String {
                rawValue
            }
        }
        
        /// Computes the filter kernel.
        func compute(sampleRate: Double) -> [Double] {
            switch kind {
            case .lowpass:
                makeLowpassFilter(
                    sampleRate: sampleRate,
                    cutoffHz: cutoffHz,
                    transitionBandwidthHz: transitionBandwidthHz
                )
            case .highpass:
                makeHighpassFilter(
                    sampleRate: sampleRate,
                    cutoffHz: cutoffHz,
                    transitionBandwidthHz: transitionBandwidthHz
                )
            }
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
            
            coefficients = params.compute(sampleRate: sampleRate)
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
        
        var params = filter
        
        // We interpret the second input as cutoff modulation.
        // TODO: Support per-sample modulation?
        // TODO: Support labeled edges to avoid hardcoding this order?
        if let modulation = inputs.count > 1 ? inputs[1].buffer.first : nil {
            params.cutoffHz = modulate(cutoffHz: params.cutoffHz, with: modulation)
        }
        
        // Recompute filter if needed
        if state.params != params || state.sampleRate != context.sampleRate {
            state = State(params: params, sampleRate: context.sampleRate, oldBuffer: state.buffer)
        }
        
        for i in 0..<output.count {
            output[i] = state.filter(input.buffer[i])
        }
        
        return input.isActive
    }
    
    func modulate(cutoffHz: Double, with modulation: Double) -> Double {
        let minHz: Double = 20
        let maxHz: Double = 20_000
        // TODO: Logarithm tables to optimize this?
        return (minHz...maxHz).clamp(exp(log(cutoffHz) + (modulation - 0.5) * modulationFactor * (log(maxHz) - log(minHz))))
    }
}
