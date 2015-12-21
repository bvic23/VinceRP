//
//  Created by Viktor Belényesi on 01/12/15.
//  Copyright © 2015 Viktor Belenyesi. All rights reserved.
//

private let globalID = AtomicLong(0)

public func nextID() -> long {
    return globalID.getAndIncrement()
}

public struct UpdateState<T> {
    
    let id: long
    let value: Try<T>
    let parents: Set<Node>
    let level: long
    
    init(_ parents: Set<Node>, _ level: long, _ timestamp: long, _ value: Try<T>) {
        self.parents = parents
        self.level = level
        self.id = timestamp
        self.value = value
    }
    
    init(_ value: Try<T>) {
        self.init(nextID(), value)
    }
    
    init(_ timestamp: long, _ value: Try<T>) {
        self.init(Set<Node>(), 0, nextID(), value)
    }
}
