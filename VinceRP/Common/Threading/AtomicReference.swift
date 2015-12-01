//
// Created by Viktor Belenyesi on 18/04/15.
// Copyright (c) 2015 Viktor Belenyesi. All rights reserved.
//

class AtomicReference<T> {
    
    private let lock = Spinlock()
    
    private var _value: T
    
    var value: T {
        
        get {
            return self.lock.around {
                self._value
            }
        }
        
        set(value) {
            self.lock.around {
                self._value = value
            }
        }
    }
    
    init(_ value: T) {
        _value = value
    }
    
}

public class Incrementing<T>: Hub<T> {
    
    private var _state: AtomicReference<UpdateState<T>>
    
    override init() {
        _state = AtomicReference(UpdateState(Try(noValueError)))
        super.init()
        _state = AtomicReference(self.makeState())
    }
    
    var state: UpdateState<T> {
        return _state.value
    }

    func toTry() -> UpdateState<T> {
        return self.state
    }
    
    func makeState() -> UpdateState<T> {
        fatalError(ABSTRACT_METHOD)
    }
    
    override func ping(incoming: Set<Node>) -> Set<Node> {
        let newState = makeState()
        
        if newState.id <= _state.value.id {
            return Set()
        }
        
        _state.value = newState
        return children
    }
    
}

let globalID = AtomicLong(0)

public func nextID() -> long {
    return globalID.getAndIncrement()
}

public struct UpdateState<T> {
    
    let id: long
    let value: Try<T>
    let parents: Set<Node>
    let level: long
    
    init(_ parents: Set<Node>, _ level: long, _ timestamp: long, _ value: Try<T>) {
        self.parents = parents
        self.level = level
        self.id = timestamp
        self.value = value
    }
    
    init(_ value: Try<T>) {
        self.init(nextID(), value)
    }
    
    init(_ timestamp: long, _ value: Try<T>) {
        self.init(Set<Node>(), 0, nextID(), value)
    }
}

