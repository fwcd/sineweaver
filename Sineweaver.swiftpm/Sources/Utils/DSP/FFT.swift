//
//  FFT.swift
//  Sineweaver
//
//  Created on 15.01.25
//

// Port of https://rosettacode.org/wiki/Fast_Fourier_transform#Python:_Recursive to Swift

func fft(_ values: [Complex]) -> [Complex] {
    let n = values.count
    guard n > 1 else { return values }
    let even = fft(stride(from: 0, to: n, by: 2).map { values[$0] })
    let odd = fft(stride(from: 1, to: n, by: 2).map { values[$0] })
    let t = odd.enumerated().map { (k, o) in
        Complex(i: -2 * .pi * Double(k) / Double(n)).exp * o
    }
    return zip(even, t).map(+) + zip(even, t).map(-)
}
