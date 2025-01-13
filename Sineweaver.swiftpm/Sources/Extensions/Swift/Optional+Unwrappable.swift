//
//  Optional+Unwrappable.swift
//  Sineweaver
//
//  Created on 27.12.24
//

extension Optional: MutablyUnwrappable {
    var unwrapped: Wrapped {
        get { self! }
        set { self = newValue }
    }
    
    func unwrapped(or defaultValue: Wrapped) -> Wrapped {
        self ?? defaultValue
    }
}
