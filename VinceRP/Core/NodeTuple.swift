//
//  NodeTuple.swift
//  VinceRP
//
//  Created by Viktor Belényesi on 11/3/15.
//  Copyright © 2015 Viktor Belenyesi. All rights reserved.
//

struct NodeTuple: Hashable, Equatable {
    let source: Node
    let reactor: Node
    
    init(_ e: Node, _ r: Node) {
        self.source = e
        self.reactor = r
    }
    
    var hashValue: Int {
        return source.hashValue ^ reactor.hashValue
    }
}
