//
// Created by Viktor Belenyesi on 27/04/15.
// Copyright (c) 2015 Viktor Belenyesi. All rights reserved.
//

protocol UpdateProtocol {
    func ancestors() -> [NodeTuple]
}

public struct BatchUpdate<T> {
    var updates: [UpdateProtocol]
    
    init(_ v: Source<T>, withValue t: T) {
        self.updates = [Update(v, t)]
    }
    
    init(updates: [UpdateProtocol], u: Update<T>) {
        self.updates = updates.arrayByAppending(u)
    }
    
    func and(v: Source<T>, withValue t: T) -> BatchUpdate {
        return BatchUpdate(updates: self.updates, u: Update(v, t))
    }
    
    func now() {
        Propagator().propagate(self.updates.flatMap {
            $0.ancestors()
        })
    }
    
}

struct Update<T>: UpdateProtocol {
    let v: Source<T>
    let t: T
    
    init(_ v: Source<T>, _ t: T) {
        self.v = v
        self.t = t
        v.updateSilent(t)
    }
    
    func ancestors() -> [NodeTuple] {
        return Array(self.v.children).map {
            NodeTuple($0, $0)
        }
    }
    
}
