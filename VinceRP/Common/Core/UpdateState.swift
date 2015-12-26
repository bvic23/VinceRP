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
    
    init(_ value: Try<T>, _ timestamp: long = nextID(), _ parents: Set<Node> = Set(), _ level: long = 0) {
        self.parents = parents
        self.level = level
        self.id = timestamp
        self.value = value
    }
}
