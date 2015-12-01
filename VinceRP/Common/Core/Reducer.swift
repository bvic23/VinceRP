//
// Created by Viktor Belenyesi on 13/09/15.
// Copyright (c) 2015 Viktor Belenyesi. All rights reserved.
//

class Reducer<T>: Wrapper<T, T> {
    
    private let transformer: (SpinState<T>, Try<T>) -> SpinState<T>
    
    init(_ source: Hub<T>, _ transformer: (SpinState<T>, Try<T>) -> SpinState<T>) {
        self.transformer = transformer
        super.init(source)
    }
    
    override func makeState() -> SpinState<T> {
        return transformer(self.state, source.toTry())
    }
    
}

public extension Hub {
    
    public func filter(successPred: T -> Bool) -> Hub<T>  {
        return Reducer(self) { (x, y) in
            switch (x, y) {
            case (_, .Success(let value)) where successPred(value): return SpinState(y)
            case (_, .Failure(_)): return SpinState(y)
            default: return x
            }
        }
    }
    
    public func filterAll(predicate: Try<T> -> Bool) -> Hub<T> {
        return Reducer(self) { (x, y) in
            guard predicate(y) else {
                return x
            }
            return SpinState(y)
        }
    }
    
    public func reduce(combiner: (T, T) -> T) -> Hub<T> {
        return Reducer(self) { (x, y) in
            switch (x.value, y) {
            case (.Success(let a), .Success(let b)): return SpinState(Try(combiner(a, b)))
            default: return SpinState(y)
            }
        }
    }
    
    public func reduceAll(combiner: (SpinState<T>, Try<T>) -> SpinState<T>) -> Hub<T> {
        return Reducer(self, combiner)
    }

}
