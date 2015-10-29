//
// Created by Viktor Belenyesi on 27/09/15.
// Copyright (c) 2015 Viktor Belenyesi. All rights reserved.
//

// TODO: add tests
public extension Rx where T:BooleanType {
    
    public func not() -> Rx<Bool> {
        return self.map(!)
    }
    
}

public extension Rx {
    
    public func foreach(skipInitial: Bool = false, callback: T -> ()) -> ChangeObserver {
        let obs = ChangeObserver(source:self, callback:{callback(self.value())}, skipInitial:skipInitial)
        return obs
    }
    
    public func skipErrors() -> Rx<T> {
        return filterAll { $0.isSuccess() }
    }
    
    public func filter(successPred: T -> Bool) -> Rx<T>  {
        return Reducer(self) { (x, y) in
            switch (x, y) {
            case (_, .Success(let box)) where successPred(box.value): return .Success(box)
            case (_, .Failure(let error)): return .Failure(error)
            case(let old, _): return old
            }
        }
    }
    
    public func filterAll(predicate: Try<T> -> Bool) -> Rx<T> {
        return Reducer(self) { (x, y) in
            guard predicate(y) else {
                return x
            }
            return y
        }
    }
    
    public func map<A>(f: T -> A) -> Rx<A> {
        return Mapper<T, A>(self) { x in
            return x.map(f)
        }
    }
    
    public func mapAll<A>(f: Try<T> -> Try<A>) -> Rx<A> {
        return Mapper<T, A>(self, f)
    }
    
    public func reduce(combiner: (T, T) -> T) -> Rx<T> {
        return Reducer(self) { (x, y) in
            switch (x, y) {
            case (.Success(let a), .Success(let b)): return Try(combiner(a.value, b.value))
            case (.Failure(_), .Success(let b)): return .Success(b)
            case (.Success(_), .Failure(let b)): return .Failure(b)
            case (.Failure(_), .Failure(let b)): return .Failure(b)
            }
        }
    }
    
    public func reduceAll(combiner: (Try<T>, Try<T>) -> Try<T>) -> Rx<T> {
        return Reducer(self, combiner)
    }
    
}
