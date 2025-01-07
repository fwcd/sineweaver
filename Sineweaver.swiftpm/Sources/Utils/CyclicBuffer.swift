//
//  CyclicBuffer.swift
//  Sineweaver
//
//  Created on 04.01.25
//

struct CyclicBuffer<Value>: Sequence, CustomStringConvertible {
    let size: Int
    
    private var data: [Value]
    private var headIndex: Int = 0

    var count: Int {
        data.count
    }
    
    var description: String {
        String(describing: Array(self))
    }
    
    fileprivate init(size: Int, data: [Value] = []) {
        self.size = size
        self.data = data
    }

    init(size: Int) {
        self.init(size: size, data: [])
    }
    
    mutating func append(_ value: Value) {
        if data.count < size {
            data.append(value)
        } else {
            headIndex %= size
            data[headIndex] = value
        }
        headIndex += 1
    }
    
    static func +=(lhs: inout Self, rhs: some Sequence<Value>) {
        for value in rhs {
            lhs.append(value)
        }
    }

    struct Iterator: IteratorProtocol {
        let buffer: CyclicBuffer<Value>
        var i = 0

        mutating func next() -> Value? {
            guard i < buffer.count else { return nil }
            let value = buffer.data[(i + buffer.headIndex) % buffer.count]
            i += 1
            return value
        }
    }
    
    func makeIterator() -> Iterator {
        Iterator(buffer: self)
    }
}

extension CyclicBuffer where Value: AdditiveArithmetic {
    static func zeros(size: Int) -> Self {
        Self(size: size, data: Array(repeating: .zero, count: size))
    }
}

extension CyclicBuffer: Equatable where Value: Equatable {}
extension CyclicBuffer: Hashable where Value: Hashable {}
extension CyclicBuffer: Sendable where Value: Sendable {}
extension CyclicBuffer: Encodable where Value: Encodable {}
extension CyclicBuffer: Decodable where Value: Decodable {}
