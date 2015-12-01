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
    
    private var _state: AtomicReference<SpinState<T>>
    
    override init() {
        _state = AtomicReference(SpinState(Try(noValueError)))
        super.init()
        _state = AtomicReference(self.makeState())
    }
    
    func state() -> SpinState<T> {
            return _state.value
    }

    func setState(state: SpinState<T>) {
        _state.value = state
    }

    func toTry() -> SpinState<T> {
        return self.state()
    }
    
    func makeState() -> SpinState<T> {
        fatalError(ABSTRACT_METHOD)
    }
    
    override func ping(incoming: Set<Node>) -> Set<Node> {
        let newState = makeState()
        
        if newState.timestamp <= _state.value.timestamp {
            return Set()
        }
        
        self.setState(newState)
        return children
    }
    
}

public let updateCount = AtomicLong(0)

public func getStamp() -> long {
    return updateCount.getAndIncrement()
}

public class SpinState<T> {
    
    let timestamp: long
    let value: Try<T>
    
    init(_ value: Try<T>) {
        self.timestamp = getStamp()
        self.value = value
    }
    
    init(_ timestamp: long, _ value: Try<T>) {
        self.timestamp = timestamp
        self.value = value
    }
}

