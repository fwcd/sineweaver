//
//  DiffUpdate.swift
//  Sineweaver
//
//  Created on 26.11.24
//

struct DiffUpdate<ID>: Hashable where ID: Hashable {
    let addedIds: Set<ID>
    let removedIds: Set<ID>
}

extension DiffUpdate: Sendable where ID: Sendable {}
