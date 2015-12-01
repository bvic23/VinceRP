//
// Created by Viktor Belenyesi on 13/09/15.
// Copyright (c) 2015 Viktor Belenyesi. All rights reserved.
//

class Reducer<T>: Wrapper<T, T> {
    
    private let transformer: (UpdateState<T>, Try<T>) -> UpdateState<T>
    
    init(_ source: Hub<T>, _ transformer: (UpdateState<T>, Try<T>) -> UpdateState<T>) {
        self.transformer = transformer
        super.init(source)
    }
    
    override func makeState() -> UpdateState<T> {
        return transformer(self.state, source.toTry())
    }
    
}

public extension Hub {
    
    public func filter(successPred: T -> Bool) -> Hub<T>  {
        return Reducer(self) { (x, y) in
            switch (x, y) {
            case (_, .Success(let value)) where successPred(value): return UpdateState(y)
            case (_, .Failure(_)): return UpdateState(y)
            default: return x
            }
        }
    }
    
    public func filterAll(predicate: Try<T> -> Bool) -> Hub<T> {
        return Reducer(self) { (x, y) in
            guard predicate(y) else {
                return x
            }
            return UpdateState(y)
        }
    }
    
    public func reduce(combiner: (T, T) -> T) -> Hub<T> {
        return Reducer(self) { (x, y) in
            switch (x.value, y) {
            case (.Success(let a), .Success(let b)): return UpdateState(Try(combiner(a, b)))
            default: return UpdateState(y)
            }
        }
    }
    
    public func reduceAll(combiner: (UpdateState<T>, Try<T>) -> UpdateState<T>) -> Hub<T> {
        return Reducer(self, combiner)
    }

}
