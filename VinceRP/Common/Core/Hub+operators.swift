//
// Created by Viktor Belenyesi on 27/09/15.
// Copyright (c) 2015 Viktor Belenyesi. All rights reserved.
//

public extension Hub where T: BooleanType {
    
    public func not() -> Hub<Bool> {
        return self.map(!)
    }
    
}

public extension Hub where T: Equatable {
    
    public func ignore(ignorabeValue: T) -> Hub<T> {
        return self.filter { $0 != ignorabeValue }
    }

    public func distinct() -> Hub<T> {
        return Reducer(self) { (x, y) in
            switch (x.value, y) {
            case (.Success(let v1), .Success(let v2)) where v1 != v2: return UpdateState(y)
            case (.Failure(_), _): return UpdateState(y)
            case (_, .Failure(_)): return UpdateState(y)
            default: return x
            }
        }
    }
    
}


public extension Hub {
    
    public func foreach(skipInitial: Bool = false, callback: T -> ()) -> ChangeObserver<T> {
        let obs = ChangeObserver<T>(source:self, callback:{_ in callback(self.value())}, skipInitial:skipInitial)
        return obs
    }
    
    public func skipErrors() -> Hub<T> {
        return filterAll { $0.isSuccess() }
    }
    
}
