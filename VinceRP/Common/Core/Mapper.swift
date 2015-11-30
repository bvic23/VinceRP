//
// Created by Viktor Belenyesi on 13/05/15.
// Copyright (c) 2015 Viktor Belenyesi. All rights reserved.
//

class Mapper<T, A>: Wrapper<T, A> {
    
    private let transformer: Try<T> -> Try<A>
    
    init(_ source: Hub<T>, _ transformer: Try<T> -> Try<A>) {
        self.transformer = transformer
        super.init(source)
    }
    
    override func state() -> AtomicReference<SpinState<A>> {
        return AtomicReference(makeState())
    }
    
    override func makeState() -> SpinState<A> {
        return SpinState(getStamp(), transformer(source.toTry()))
    }
    
}

public extension Hub {
    
    public func map<A>(f: T -> A) -> Hub<A> {
        return Mapper<T, A>(self) { x in
            return x.map(f)
        }
    }
    
    public func mapAll<A>(f: Try<T> -> Try<A>) -> Hub<A> {
        return Mapper<T, A>(self, f)
    }
    
}
