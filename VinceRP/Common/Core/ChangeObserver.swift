//
// Created by Viktor Belenyesi on 13/04/15.
// Copyright (c) 2015 Viktor Belenyesi. All rights reserved.
//

private var changeObservers = Set<Node>()

public class ChangeObserver<T>: Hub<T> {    

    let source: Node
    let callback: () -> ()
    
    public init(source: Node, callback: () -> (), skipInitial: Bool = false) {
        self.source = source
        self.callback = callback
        
        super.init()
        
        source.linkChild(self)
        
        if (!skipInitial) {
            trigger()
        }
        
        changeObservers.insert(self)
    }
    
    override public var parents: Set<Node> {
        return toSet(source)
    }
    
    override var level: long {
        return long.max
    }
    
    override func ping(incoming: Set<Node>) -> Set<Node> {
        if (!parents.intersect(incoming).isEmpty && source.isSuccess()) {
            dispatch(callback)
        }
        return Set()
    }
    
    private func trigger() {
        ping(parents)
    }
    
    override public func kill() {
        super.kill()
        changeObservers.remove(self)
    }
    
}
