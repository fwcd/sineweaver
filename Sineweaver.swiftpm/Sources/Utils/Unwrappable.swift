//
//  Unwrappable.swift
//  Sineweaver
//
//  Created on 27.12.24
//

protocol Unwrappable {
    associatedtype Wrapped
    
    var unwrapped: Wrapped { get }
}

protocol MutablyUnwrappable: Unwrappable {
    associatedtype Wrapped
    
    var unwrapped: Wrapped { get set }
}

