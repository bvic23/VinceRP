//
// Created by Viktor Belenyesi on 13/04/15.
// Copyright (c) 2015 Viktor Belenyesi. All rights reserved.
//

public class ChangeObserver: Node {
    
    private static var changeObservers = Set<ChangeObserver>()
    
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
        
        ChangeObserver.changeObservers.insert(self)
    }
    
    override public var parents: Set<Node> {
        return toSet(source)
    }
    
    override var level: long {
        return long.max
    }
    
    override func ping(incoming: Set<Node>) -> Set<Node> {
        if (!parents.intersect(incoming).isEmpty && source.isSuccess()) {
            callback()
        }
        return Set()
    }
    
    private func trigger() {
        ping(parents)
    }
    
    override public func kill() {
        super.kill()
        ChangeObserver.changeObservers.remove(self)
    }
    
}