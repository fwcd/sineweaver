//
//  Normalize.swift
//  Sineweaver
//
//  Created on 25.12.24
//

extension Range where Bound: BinaryFloatingPoint {
    var length: Bound {
        upperBound - lowerBound
    }
    
    func normalize(_ value: Bound) -> Bound {
        (value - lowerBound) / length
    }
    
    func denormalize(_ value: Bound) -> Bound {
        value * length + lowerBound
    }
}

extension ClosedRange where Bound: BinaryFloatingPoint {
    var length: Bound {
        upperBound - lowerBound
    }
    
    func normalize(_ value: Bound) -> Bound {
        (value - lowerBound) / length
    }
    
    func denormalize(_ value: Bound) -> Bound {
        value * length + lowerBound
    }
}
