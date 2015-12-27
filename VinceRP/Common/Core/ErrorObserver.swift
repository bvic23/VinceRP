//
// Created by Viktor Belenyesi on 27/09/15.
// Copyright (c) 2015 Viktor Belenyesi. All rights reserved.
//

import Foundation

private var errorObservers = Set<Node>()

public class ErrorObserver<T>: ChangeObserver<T> {
    
    public init(source: Node, callback: (NSError?) -> (), name: String = "") {
        super.init(source:source, callback: callback, skipInitial:true)
        errorObservers.insert(self)
    }
    
    override func ping(incoming: Set<Node>) -> Set<Node> {
        if (!parents.intersect(incoming).isEmpty && !source.isSuccess()) {
            dispatch {
                if let s = self.source as? Hub<T>,
                   case .Failure(let error) = s.toTry() {
                    self.callback(error)
                }
            }
        }
        return Set()
    }
    
    override public func kill() {
        super.kill()
        errorObservers.remove(self)
    }
    
}

