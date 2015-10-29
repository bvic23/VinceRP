//
// Created by Viktor Belenyesi on 27/09/15.
// Copyright (c) 2015 Viktor Belenyesi. All rights reserved.
//

class Wrapper<T:Equatable, A:Equatable> : Spinlock<A> {
    
    let source : Rx<T>
    
    init(_ source: Rx<T>) {
        self.source = source
        super.init()
        source.linkChild(self)
    }
    
    override var level: long {
        get {
            return self.source.level + 1
        }
    }
    
    override var parents: Set<Node> {
        get {
            return toSet(source)
        }
    }
    
    override func toTry() -> Try<A> {
        return self.state().value.value
    }
    
}
