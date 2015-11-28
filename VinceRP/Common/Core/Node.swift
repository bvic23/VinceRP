//
// Created by Viktor Belenyesi on 19/04/15.
// Copyright (c) 2015 Viktor Belenyesi. All rights reserved.
//

public class Node: Hashable {

    private static var hashCounter = AtomicLong(0)
    private let childrenHolder = SpinSet<WeakSet<Node>>(WeakSet())
    public let hashValue = Int(Node.hashCounter.getAndIncrement())  // Hashable

    public var children: Set<Node> {
        return childrenHolder.value.filter {
            $0.parents.contains(self)
        }.set
    }

    public var descendants: Set<Node> {
        return children ++ children.flatMap {
            $0.descendants
        }
    }

    public var parents: Set<Node> {
        return Set()
    }

    public var ancestors: Set<Node> {
        return parents ++ parents.flatMap {
            $0.ancestors
        }
    }

    func isSuccess() -> Bool {
        return true
    }

    func error() -> NSError {
        fatalError(ABSTRACT_METHOD)
    }

    func linkChild(child: Node) {
        childrenHolder.spinSet { c in
            guard (c.hasElementPassingTest {$0 == child}) else {
                c.insert(child)
                return c
            }
            return c
        }
    }

    func unlinkChild(child: Node) {
        childrenHolder.spinSet {
            $0.filter {
                $0 != child
            }
        }
    }

    func ping(incoming: Set<Node>) -> Set<Node> {
        fatalError(ABSTRACT_METHOD)
    }
    
    private var alive = true
    
    public func kill() {
        alive = false
        parents.forEach {
            $0.unlinkChild(self)
        }
    }

    var level: long {
        return 0
    }

}

public func ==(lhs: Node, rhs: Node) -> Bool {
    return lhs.hashValue == rhs.hashValue
}

