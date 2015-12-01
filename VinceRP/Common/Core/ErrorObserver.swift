//
// Created by Viktor Belenyesi on 27/09/15.
// Copyright (c) 2015 Viktor Belenyesi. All rights reserved.
//

import Foundation

public class ErrorObserver: ChangeObserver {
    
    private static var errorObservers = Set<ErrorObserver>()
    private var errorCallback: (NSError) -> ()
    
    public init(source: Node, callback: (NSError) -> (), name: String = "") {
        self.errorCallback = callback
        super.init(source:source, callback:({}), skipInitial:true)
        ErrorObserver.errorObservers.insert(self)
  //      self.dispatchOnMainQueue()
    }
    
    override func ping(incoming: Set<Node>) -> Set<Node> {
        if (!parents.intersect(incoming).isEmpty && !source.isSuccess()) {
            if let q = dispatchQueue {
                dispatch_async(q) {
                    self.errorCallback(self.source.error())
                }
            } else {
                self.errorCallback(source.error())
            }
        }
        return Set()
    }
    
    override public func kill() {
        super.kill()
        ErrorObserver.errorObservers.remove(self)
    }
    
}

