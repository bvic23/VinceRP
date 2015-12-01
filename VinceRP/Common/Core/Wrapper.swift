//
// Created by Viktor Belenyesi on 27/09/15.
// Copyright (c) 2015 Viktor Belenyesi. All rights reserved.
//

class Wrapper<T, A>: Incrementing<A> {
    
    let source: Hub<T>
    
    init(_ source: Hub<T>) {
        self.source = source
        super.init()
        source.linkChild(self)
    }
    
    override var level: long {
        return self.source.level + 1
    }
    
    override var parents: Set<Node> {
        return toSet(source)
    }
    
    override func toTry() -> Try<A> {
        return self.state().value
    }
    
}
