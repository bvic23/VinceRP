//
// Created by Viktor Belenyesi on 11/3/15.
// Copyright (c) 2015 Viktor Belenyesi. All rights reserved.
//

struct NodeTuple: Hashable {
    let source: Node
    let reactor: Node

    init(_ source: Node, _ reactor: Node) {
        self.source = source
        self.reactor = reactor
    }

    var hashValue: Int {
        return source.hashValue ^ reactor.hashValue
    }
}
