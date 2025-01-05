//
//  Duration+Extensions.swift
//  Sineweaver
//
//  Created on 05.01.25
//

extension Duration {
    var asMilliseconds: Double {
        get { self / .milliseconds(1) }
        set { self = .milliseconds(newValue) }
    }
    
    var asSeconds: Double {
        get { self / .seconds(1) }
        set { self = .seconds(newValue) }
    }
}
