//
//  CyclicBuffer.swift
//  Sineweaver
//
//  Created on 04.01.25
//

struct CyclicBuffer<Value>: Sequence, CustomStringConvertible {
    let size: Int
    
    private var data: [Value] = []
    private var headIndex: Int = 0

    var count: Int {
        data.count
    }
    
    var description: String {
        String(describing: Array(self))
    }

    init(size: Int) {
        self.size = size
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

extension CyclicBuffer: Equatable where Value: Equatable {}
extension CyclicBuffer: Hashable where Value: Hashable {}
extension CyclicBuffer: Sendable where Value: Sendable {}
extension CyclicBuffer: Encodable where Value: Encodable {}
extension CyclicBuffer: Decodable where Value: Decodable {}
