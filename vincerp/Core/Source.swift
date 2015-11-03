//
// Created by Viktor Belenyesi on 15/09/15.
// Copyright (c) 2015 Viktor Belenyesi. All rights reserved.
//

public class Source<T:Equatable>: Rx<T> {
    
    let state: AtomicReference<Box<Try<T>>>

    public init(initValue: T) {
        self.state = AtomicReference(Box(Try(initValue)))
        super.init()
    }
    
    public func update(newValue: T) {
        guard let q = dispatchQueue else {
            self.updateSilent(newValue)
            self.propagate()
            return
        }
        dispatch_async(q) {
            self.updateSilent(newValue)
            self.propagate()
        }
    }
    
    public func error(error: NSError) {
        self.state.value = Box(Try(error))
        propagate()
    }
    
    public func updateSilent(newValue:T) {
        self.state.value = Box(Try(newValue))
    }
    
    override var level: long {
        return 0
    }
    
    override func isSuccess() -> Bool {
        return self.state.value.value.isSuccess()
    }
    
    override public func toTry() -> Try<T> {
        return self.state.value.value
    }
    
    override public var parents: Set<Node> {
        return Set()
    }
    
    override func ping(incoming: Set<Node>) -> Set<Node> {
        return children
    }
    
}



