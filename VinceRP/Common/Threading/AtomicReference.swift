//
// Created by Viktor Belenyesi on 18/04/15.
// Copyright (c) 2015 Viktor Belenyesi. All rights reserved.
//

public class AtomicReference<T: AnyObject> {
    
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
    
    public init(_ value: T) {
        _value = value
    }
    
}


public class Incrementing<T>: Hub<T> {
    
    private let updateCount = AtomicLong(0)
    public var oldValue: AtomicReference<SpinState<T>>?
    
    func state() -> AtomicReference<SpinState<T>> {
        if let s = oldValue {
            return s
        }
        oldValue = AtomicReference(self.makeState())
        return oldValue!
    }
    
    func setState(newValue: AtomicReference<SpinState<T>>) {
        oldValue = newValue
    }
    
    func getStamp() -> long {
        return updateCount.getAndIncrement()
    }
    
    func toTry() -> SpinState<T> {
        return self.state().value
    }
    
    func makeState() -> SpinState<T> {
        fatalError(ABSTRACT_METHOD)
    }
    
    override func ping(incoming: Set<Node>) -> Set<Node> {
        var oldValue: SpinState<T>? = nil
        
        if let l = self.oldValue {
            oldValue = l.value
        }
        
        let newState = makeState()
        let s = self.state()
        if (newState.timestamp >= s.value.timestamp) {
            s.value = newState
        }
        
        if let ov = oldValue where s.value.checkEquality(ov) {
            return Set()
        }
        return children
    }
    
}

public class SpinState<T> {
    
    let timestamp: long
    let value: Try<T>
    
    init(_ timestamp: long, _ value: Try<T>) {
        self.timestamp = timestamp
        self.value = value
    }
    
    func checkEquality(other: SpinState<T>) -> Bool {
        let lhs = self.value
        let rhs = other.value
        
        switch (lhs, rhs) {
        case (.Success(let l), .Success(let r)): return l === r
        case (.Failure(let l), .Failure(let r)): return l == r
        default: return false
        }
    }
    
}

