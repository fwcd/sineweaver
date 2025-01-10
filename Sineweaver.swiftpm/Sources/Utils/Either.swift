//
//  Either.swift
//  Sineweaver
//
//  Created on 10.01.25
//

enum Either<Left, Right> {
    case left(Left)
    case right(Right)
}

extension Either: Equatable where Left: Equatable, Right: Equatable {}
extension Either: Hashable where Left: Hashable, Right: Hashable {}
extension Either: Sendable where Left: Sendable, Right: Sendable {}
extension Either: Encodable where Left: Encodable, Right: Encodable {}
extension Either: Decodable where Left: Decodable, Right: Decodable {}
