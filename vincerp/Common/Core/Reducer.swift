//
// Created by Viktor Belenyesi on 13/09/15.
// Copyright (c) 2015 Viktor Belenyesi. All rights reserved.
//

class Reducer<T:Equatable> : Wrapper<T, T> {
    
    private let transformer: (Try<T>, Try<T>) -> Try<T>
    
    init(_ source: Hub<T>, _ transformer: (Try<T>, Try<T>) -> Try<T>) {
        self.transformer = transformer
        super.init(source)
        self.setState(SpinSet(SpinState(getStamp(), source.toTry())))
    }
    
    override func makeState() -> SpinState<T> {
        return SpinState(getStamp(), transformer(self.state().value.value, source.toTry()))
    }
    
}

public extension Hub {
    
    public func filter(successPred: T -> Bool) -> Hub<T>  {
        return Reducer(self) { (x, y) in
            switch (x, y) {
            case (_, .Success(let box)) where successPred(box.value): return .Success(box)
            case (_, .Failure(let error)): return .Failure(error)
            case(let old, _): return old
            }
        }
    }
    
    public func filterAll(predicate: Try<T> -> Bool) -> Hub<T> {
        return Reducer(self) { (x, y) in
            guard predicate(y) else {
                return x
            }
            return y
        }
    }
    
    public func reduce(combiner: (T, T) -> T) -> Hub<T> {
        return Reducer(self) { (x, y) in
            switch (x, y) {
            case (.Success(let a), .Success(let b)): return Try(combiner(a.value, b.value))
            case (.Failure(_), .Success(let b)): return .Success(b)
            case (.Success(_), .Failure(let b)): return .Failure(b)
            case (.Failure(_), .Failure(let b)): return .Failure(b)
            }
        }
    }
    
    public func reduceAll(combiner: (Try<T>, Try<T>) -> Try<T>) -> Hub<T> {
        return Reducer(self, combiner)
    }

}
