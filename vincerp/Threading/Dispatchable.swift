//
// Created by Viktor Belenyesi on 27/09/15.
// Copyright (c) 2015 Viktor Belenyesi. All rights reserved.
//

// TODO: add tests
public protocol Dispatchable {
    typealias D
    
    func dispatchOnThread(dispatchQueue: dispatch_queue_t!) -> D
    func dispatchOnMainThread() -> D
    func dispatchOnCurrentThread() -> D
    func dispatchOnBackgroundThread() -> D
    
}

public extension Dispatchable {
    
    public func dispatchOnMainThread() -> D {
        return self.dispatchOnThread(dispatch_get_main_queue())
    }
    
    public func dispatchOnCurrentThread() -> D {
        return self.dispatchOnThread(nil)
    }
    
    public func dispatchOnBackgroundThread() -> D {
        return self.dispatchOnThread(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0))
    }
    
}
