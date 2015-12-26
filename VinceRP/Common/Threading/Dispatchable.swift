//
// Created by Viktor Belenyesi on 27/09/15.
// Copyright (c) 2015 Viktor Belenyesi. All rights reserved.
//

public protocol Dispatchable {
    typealias D
    
    var dispatchQueue: dispatch_queue_t? { get set }
    
    func dispatchOnQueue(dispatchQueue: dispatch_queue_t?) -> D
    func dispatchOnMainQueue() -> D
    func dispatchOnCurrentQueue() -> D
    func dispatchOnBackgroundQueue() -> D
    func dispatch(thunk: () -> ())
}

public extension Dispatchable {
    
    public func dispatchOnMainQueue() -> D {
        return self.dispatchOnQueue(dispatch_get_main_queue()!)
    }
    
    public func dispatchOnCurrentQueue() -> D {
        return self.dispatchOnQueue(nil)
    }
    
    public func dispatchOnBackgroundQueue() -> D {
        return self.dispatchOnQueue(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)!)
    }
    
    public func dispatch(thunk: () -> ()) {
        if let q = dispatchQueue {
            dispatch_async(q) {
                thunk()
            }
        } else {
            thunk()
        }
    }
    
}
