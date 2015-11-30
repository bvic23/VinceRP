//
// Created by Viktor Belenyesi on 13/04/15.
// Copyright (c) 2015 Viktor Belenyesi. All rights reserved.
//

public class ChangeObserver: Node {
    
    private static var changeObservers = Set<ChangeObserver>()
    var dispatchQueue: dispatch_queue_t!

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
        self.dispatchOnMainQueue()
    }
    
    override public var parents: Set<Node> {
        return toSet(source)
    }
    
    override var level: long {
        return long.max
    }
    
    override func ping(incoming: Set<Node>) -> Set<Node> {
        if (!parents.intersect(incoming).isEmpty && source.isSuccess()) {
            if let q = dispatchQueue {
                dispatch_async(q) {
                    self.callback()
                }
            } else {
                callback()
            }
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

extension ChangeObserver: Dispatchable {
    
    public func dispatchOnQueue(dispatchQueue: dispatch_queue_t?) -> ChangeObserver {
        self.dispatchQueue = dispatchQueue
        return self
    }
    
}