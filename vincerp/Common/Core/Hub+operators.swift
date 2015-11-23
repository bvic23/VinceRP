//
// Created by Viktor Belenyesi on 27/09/15.
// Copyright (c) 2015 Viktor Belenyesi. All rights reserved.
//

// TODO: add tests
public extension Hub where T: BooleanType {
    
    public func not() -> Hub<Bool> {
        return self.map(!)
    }
    
}

public extension Hub {
    
    public func foreach(skipInitial: Bool = false, callback: T -> ()) -> ChangeObserver {
        let obs = ChangeObserver(source:self, callback:{callback(self.value())}, skipInitial:skipInitial)
        return obs
    }
    
    public func skipErrors() -> Hub<T> {
        return filterAll { $0.isSuccess() }
    }

    public func ignore(ignorabeValues: T) -> Hub<T> {
        return self.filter { $0 != ignorabeValues }
    }
    
}
