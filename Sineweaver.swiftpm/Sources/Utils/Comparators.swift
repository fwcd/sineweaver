//
//  Comparators.swift
//  Sineweaver
//
//  Created on 04.01.25
//

func ascendingComparator<C, T>(by mapper: @escaping (C) -> T) -> (C, C) -> Bool where T: Comparable {
    {
        mapper($0) < mapper($1)
    }
}
