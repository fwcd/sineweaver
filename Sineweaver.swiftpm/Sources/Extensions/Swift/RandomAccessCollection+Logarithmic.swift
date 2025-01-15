//
//  RandomAccessCollection+Logarithmic.swift
//  Sineweaver
//
//  Created on 15.01.25
//

import Foundation

extension RandomAccessCollection where Index == Int {
    func logarithmicallySampled(base: Double) -> [Element] {
        guard let first else { return [] }
        var values = Array(repeating: first, count: Int((log(Double(count)) / log(base)).rounded(.down)))
        var j: Double = 1
        for i in 0..<values.count {
            values[i] = self[Int(j)]
            j *= base
        }
        return values
    }
}
