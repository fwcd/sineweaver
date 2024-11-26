//
//  DiffUpdatable.swift
//  Sineweaver
//
//  Created on 26.11.24
//

@MainActor
protocol DiffUpdatable {
    associatedtype Child = Self
    
    func addChildForDiffUpdate(_ child: Child)
    
    func removeChildForDiffUpdate(_ child: Child)
}

extension DiffUpdatable {
    /// Performs an efficient update of the given children that only adds/removes
    /// what has changed between the children and the model items.
    @discardableResult
    func diffUpdate<I, ID>(nodes: inout [ID: Child], with items: [ID: I], using factory: (ID, I) -> Child) -> DiffUpdate<ID>
    where ID: Hashable {
        let nodeIds = Set(nodes.keys)
        let itemIds = Set(items.keys)
        let removedIds = nodeIds.subtracting(itemIds)
        let addedIds = itemIds.subtracting(nodeIds)
        
        for id in removedIds {
            removeChildForDiffUpdate(nodes[id]!)
            nodes[id] = nil
        }
        
        for id in addedIds {
            let node = factory(id, items[id]!)
            nodes[id] = node
            addChildForDiffUpdate(node)
        }
        
        return DiffUpdate(addedIds: addedIds, removedIds: removedIds)
    }
    
    /// Performs an efficient update of the given children that only adds/removes
    /// what has changed between the children and the model items.
    @discardableResult
    func diffUpdate<I, ID>(nodes: inout [ID: Child], with items: [I], id: (I) -> ID, using factory: (ID, I) -> Child) -> DiffUpdate<ID>
    where ID: Hashable {
        diffUpdate(
            nodes: &nodes,
            with: Dictionary(uniqueKeysWithValues: items.map { (id($0), $0) }),
            using: factory
        )
    }
    
    /// Performs an efficient update of the given children that only adds/removes
    /// what has changed between the children and the model items.
    @discardableResult
    func diffUpdate<I>(nodes: inout [I.ID: Child], with items: [I], using factory: (I) -> Child) -> DiffUpdate<I.ID>
    where I: Identifiable {
        diffUpdate(nodes: &nodes, with: items, id: \.id) { _, item in
            factory(item)
        }
    }
}
