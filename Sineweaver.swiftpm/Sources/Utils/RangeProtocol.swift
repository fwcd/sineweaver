//
//  RangeProtocol.swift
//  Sineweaver
//
//  Created on 25.12.24
//

protocol RangeProtocol<Bound> {
    associatedtype Bound
    
    var lowerBound: Bound { get }
    var upperBound: Bound { get }
}

extension RangeProtocol where Bound: BinaryFloatingPoint {
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
