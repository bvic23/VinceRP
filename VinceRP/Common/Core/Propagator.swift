//
// Created by Viktor Belenyesi on 18/04/15.
// Copyright (c) 2015 Viktor Belenyesi. All rights reserved.
//

func ==(lhs: NodeTuple, rhs: NodeTuple) -> Bool {
    return lhs.source.hashValue == rhs.source.hashValue && lhs.reactor.hashValue == rhs.source.hashValue
}

private let propagationQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)

public class Propagator: Dispatchable {
    
    static let instance = Propagator()
    
    public var dispatchQueue: dispatch_queue_t?
    
    public func dispatchOnQueue(dispatchQueue: dispatch_queue_t?) -> Propagator {
        self.dispatchQueue = dispatchQueue
        return self
    }
    
    var async: Bool = false {
        didSet {
            self.dispatchOnQueue(self.async ? propagationQueue : nil)
        }
    }

    func propagate(nodes: [NodeTuple]) {
        self.propagate(Set(nodes))
    }
    
    func propagate(setCalc: () -> Set<NodeTuple>) {
        self.dispatch {
            self.propagateSync(setCalc())
        }
    }

    func propagate(setCalc: () -> [NodeTuple]) {
        self.dispatch {
            self.propagateSync(Set(setCalc()))
        }
    }
    
    func propagate(nodes: Set<NodeTuple>) {
        self.dispatch {
            self.propagateSync(nodes)
        }
    }

    private func propagateSync(nodes: Set<NodeTuple>) {
        guard nodes.count > 0 else {
            return
        }
        
        let minLevel = nodes.map{ $0.reactor.level }.min(0)
        let (now, later) = nodes.partition {
            $0.reactor.level == minLevel
        }
        
        let next = now.groupBy{
            $0.reactor
            }.mapValues{
                $0.map{ $0.source }
            }.map{ (target, pingers) in
                return target.ping(pingers).map {
                    NodeTuple(target, $0)
                }
            }.flatten()
        
        propagate(next + later)
    }

}
