//
// Created by Viktor Belenyesi on 19/04/15.
// Copyright (c) 2015 Viktor Belenyesi. All rights reserved.
//

public class Node: Hashable, Equatable {

    private static var hashCounter = AtomicLong(0)
    private let childrenHolder = SpinSet<WeakSet<Node>>(WeakSet())
    public let hashValue = Int(Node.hashCounter.getAndIncrement())  // Hashable

    public var children: Set<Node> {
        get {
            return childrenHolder.value.filter {
                $0.parents.contains(self)
            }.set
        }
    }

    public var descendants: Set<Node> {
        get {
            return children ++ children.flatMap {
                $0.descendants
            }
        }
    }

    public var parents: Set<Node> {
        get {
            fatalError(ABSTRACT_METHOD)
        }
    }

    public var ancestors: Set<Node> {
        get {
            fatalError(ABSTRACT_METHOD)
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
    
    public func kill() {
        fatalError(ABSTRACT_METHOD)
    }

    var level: long {
        get {
            fatalError(ABSTRACT_METHOD)
        }
    }

}

public func ==(lhs: Node, rhs: Node) -> Bool {
    return lhs.hashValue == rhs.hashValue
}

