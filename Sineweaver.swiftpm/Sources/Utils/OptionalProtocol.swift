//
//  OptionalProtocol.swift
//  Sineweaver
//
//  Created on 10.01.25
//

protocol OptionalProtocol {
    associatedtype Wrapped
    
    static var none: Self { get }
    
    static func some(_ value: Wrapped) -> Self
}

extension Optional: OptionalProtocol {}
