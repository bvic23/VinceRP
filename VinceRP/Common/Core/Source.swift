//
// Created by Viktor Belenyesi on 15/09/15.
// Copyright (c) 2015 Viktor Belenyesi. All rights reserved.
//

let noValueError = NSError(domain: "no value", code: -1, userInfo: nil)

let q = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)

public class Source<T>: Hub<T> {
    
    let state: AtomicReference<Try<T>>

    public init(initValue: T) {
        state = AtomicReference(Try(initValue))
        super.init()
    }
    
    public override init() {
        state = AtomicReference(Try(noValueError))
        super.init()
    }
    
    public func update(newValue: T) {
        self.updateSilent(newValue)
  //      dispatch_async(q) {
            self.propagate()
    //    }
    }
    
    public func error(error: NSError) {
        self.state.value = Try(error)
        propagate()
    }
    
    public func updateSilent(newValue:T) {
        self.state.value = Try(newValue)
    }
    
    override func isSuccess() -> Bool {
        return toTry().isSuccess()
    }
    
    override public func toTry() -> Try<T> {
        return state.value
    }
    
    override func ping(incoming: Set<Node>) -> Set<Node> {
        return children
    }
    
    public func hasValue() -> Bool {
        if !isSuccess()  {
            switch toTry() {
            case .Success(_): return true
            case .Failure(let e): return e !== noValueError
            }
        }
        return true
    }
  
}
