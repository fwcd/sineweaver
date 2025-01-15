//
//  RangeReplaceableCollection+Pad.swift
//  Sineweaver
//
//  Created on 15.01.25
//

extension RangeReplaceableCollection {
    mutating func pad(to count: Int, with value: Element) {
        while self.count < count {
            append(value)
        }
    }
    
    func padded(to count: Int, with value: Element) -> Self {
        var padded = self
        padded.pad(to: count, with: value)
        return padded
    }
}
