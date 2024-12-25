//
//  Normalize.swift
//  Sineweaver
//
//  Created on 25.12.24
//

func normalize<Value>(_ value: Value, in range: Range<Value>) -> Value where Value: BinaryFloatingPoint {
    (value - range.lowerBound) / length(of: range)
}

func normalize<Value>(_ value: Value, in range: ClosedRange<Value>) -> Value where Value: BinaryFloatingPoint {
    (value - range.lowerBound) / length(of: range)
}

func length<Value>(of range: Range<Value>) -> Value where Value: BinaryFloatingPoint {
    range.upperBound - range.lowerBound
}

func length<Value>(of range: ClosedRange<Value>) -> Value where Value: BinaryFloatingPoint {
    range.upperBound - range.lowerBound
}
