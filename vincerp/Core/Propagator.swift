//
// Created by Viktor Belenyesi on 18/04/15.
// Copyright (c) 2015 Viktor Belenyesi. All rights reserved.
//

struct EmitterReactorTuple: Hashable, Equatable {
    let e: Node
    let r: Node

    init(_ e: Node, _ r: Node) {
        self.e = e
        self.r = r
    }

    var hashValue: Int {
        return e.hashValue ^ r.hashValue
    }
}

func ==(lhs: EmitterReactorTuple, rhs: EmitterReactorTuple) -> Bool {
    return lhs.e.hashValue == rhs.e.hashValue && lhs.r.hashValue == rhs.e.hashValue
}

class ImmediatePropagator {
    func propagate(nodes: [EmitterReactorTuple]) {
        self.propagate(Set(nodes))
    }

    func propagate(nodes: Set<EmitterReactorTuple>) {
        guard nodes.count > 0 else {
            return
        }
        
        let minLevel = nodes.map{ $0.r.level }.min(0)
        let (now, later) = nodes.partition {
            $0.r.level == minLevel
        }

        let next = now.groupBy{
               $0.r
        }.mapValues{
            $0.map{ $0.e }
        }.map{ (target, pingers) in
            return target.ping(pingers).map {
                EmitterReactorTuple(target, $0)
            }
        }.flatten()
           
        propagate(next + later)
    }
}
