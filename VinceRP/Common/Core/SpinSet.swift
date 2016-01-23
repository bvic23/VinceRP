//
// Created by Viktor Belenyesi on 18/04/15.
// Copyright (c) 2015 Viktor Belenyesi. All rights reserved.
//

public class SpinSet<T: AnyObject>: AtomicReference<T> {

    override init(_ t: T) {
        super.init(t)
    }

    func update(t: T) {
        super.value = t
    }

    override public var value: T {
        set {
            super.value = newValue
        }
        get {
            return super.value
        }
    }

    final func spinSet(transform: T -> T) {
        super.value = transform(self.value)
    }

//    final func spinSetOpt(transform: T -> T?) -> Bool {
//        let oldV = super.value
//        let newVOpt = transform(oldV)
//        guard let newV = newVOpt else {
//            return false
//        }        
//        if compareAndSet(oldV, newV) {
//            return true
//        }
//        return spinSetOpt(transform)
//    }

}

public class Incrementing<T>: Hub<T> {

    private let updateCount = AtomicLong(0)
    public var oldValue: SpinSet<SpinState<T>>?
    
    func state() -> SpinSet<SpinState<T>> {
        if let s = oldValue {
            return s
        }
        oldValue = SpinSet(self.makeState())
        return oldValue!
    }
    
    func setState(newValue: SpinSet<SpinState<T>>) {
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

}

public class Spinlock<T>: Incrementing<T> {
    
    override func ping(incoming: Set<Node>) -> Set<Node> {
        var oldValue: SpinState<T>? = nil
        
        if let l = self.oldValue {
            oldValue = l.value
        }
        
        let newState = makeState()
        let s = self.state()
//        s.spinSetOpt {
            if (newState.timestamp >= s.value.timestamp) {
                self.state().value = newState
            }
  //      }
        
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

