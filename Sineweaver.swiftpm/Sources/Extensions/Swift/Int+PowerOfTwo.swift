//
//  Int+PowerOfTwo.swift
//  Sineweaver
//
//  Created on 15.01.25
//

extension BinaryInteger {
    var powerOfTwoFloor: Self {
        var power: Self = 1
        while (power * 2) <= self {
            power *= 2
        }
        return power
    }
    
    var powerOfTwoCeil: Self {
        var power: Self = 1
        while power < self {
            power *= 2
        }
        return power
    }
}
