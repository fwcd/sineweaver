//
//  Filters.swift
//  Sineweaver
//
//  Created on 07.01.25
//

// An implementation of some low-pass and high-pass filters based on Tom Roelandt's amazing introduction to windowed-sinc filters:
// - https://tomroelandts.com/articles/how-to-create-a-simple-low-pass-filter
// - https://tomroelandts.com/articles/how-to-create-a-simple-high-pass-filter

import Foundation
import SwiftUI // only for the preview

/// Computes a point of the sinc function.
func sinc(_ x: Double) -> Double {
    x == 0 ? 1 : (sin(x) / x)
}

/// Computes a point of a Blackman window of the given width.
func blackmanWindow(width: Double, _ x: Double) -> Double {
    0.42 - 0.5 * cos(2 * .pi * x / (width - 1)) + 0.08 * cos(4 * .pi * x / (width - 1))
}

/// Computes a point of an ideal sinc (low-pass) filter.
///
/// The cutoff frequency is specified as a fraction of the sample rate.
func sincFilter(cutoff: Double, _ x: Double) -> Double {
    2 * cutoff * sinc(2 * cutoff * x)
}

/// Computes a point of a windowed-sinc (low-pass) filter.
///
/// The cutoff frequency is specified as a fraction of the sample rate.
func windowedSincFilter(cutoff: Double, width: Double, _ x: Double) -> Double {
    return sincFilter(cutoff: cutoff, x - (width - 1) / 2) * blackmanWindow(width: width, x)
}

/// Approximates the filter width given a transition bandwidth.
///
/// The bandwidth is specified as a fraction of the sample rate.
func filterWidth(transitionBandwidth: Double) -> Double {
    4 / transitionBandwidth
}

/// Normalizes the given filter to sum to one, resulting in unity gain.
func normalized(filter: [Double]) -> [Double] {
    let sum = filter.reduce(0, +)
    return filter.map { $0 / sum }
}

/// Performs spectral inversion on the given filter.
func spectralInversion(filter: [Double]) -> [Double] {
    var filter = filter.map { -$0 }
    filter[filter.count / 2] += 1
    return filter
}

/// Creates a full (sampled) low-pass filter.
func makeLowpassFilter(sampleRate: Double, cutoffHz: Double, transitionBandwidthHz: Double) -> [Double] {
    let cutoff = cutoffHz / sampleRate
    let transitionBandwidth = transitionBandwidthHz / sampleRate
    let width = filterWidth(transitionBandwidth: transitionBandwidth).rounded(.up)
    let filter = (0..<Int(width)).map { windowedSincFilter(cutoff: cutoff, width: width, Double($0)) }
    return normalized(filter: filter)
}

/// Creates a full (sampled) high-pass filter.
func makeHighpassFilter(sampleRate: Double, cutoffHz: Double, transitionBandwidthHz: Double) -> [Double] {
    let lowpass = makeLowpassFilter(
        sampleRate: sampleRate,
        cutoffHz: cutoffHz,
        transitionBandwidthHz: transitionBandwidthHz
    )
    return spectralInversion(filter: lowpass)
}

#Preview {
    let sampleRate: Double = 100
    let cutoffHz: Double = 60
    let width: Double = 100
    let xRange: Range<Double> = 0..<width
    VStack {
        Section("Filter functions") {
            ChartView(xRange: xRange) { x in
                sinc(x)
            }
            ChartView(xRange: xRange) { x in
                blackmanWindow(width: width, x)
            }
            ChartView(xRange: xRange) { x in
                sincFilter(cutoff: cutoffHz / sampleRate, x - (width - 1) / 2)
            }
            ChartView(xRange: xRange) { x in
                windowedSincFilter(cutoff: cutoffHz / sampleRate, width: width, x)
            }
        }
        
        let transitionBandwidthHz = 4.0
        
        Section("Low-pass filter") {
            ChartView(ys: makeLowpassFilter(sampleRate: sampleRate, cutoffHz: cutoffHz, transitionBandwidthHz: transitionBandwidthHz))
        }
        
        Section("High-pass filter") {
            ChartView(ys: makeHighpassFilter(sampleRate: sampleRate, cutoffHz: cutoffHz, transitionBandwidthHz: transitionBandwidthHz))
        }
    }
}
