//
// Created by Viktor Belenyesi on 13/05/15.
// Copyright (c) 2015 Viktor Belenyesi. All rights reserved.
//

class Mapper<T:Equatable, A:Equatable> : Wrapper<T, A> {
    
    private let transformer: Try<T> -> Try<A>
    
    init(_ source: Rx<T>, _ transformer: Try<T> -> Try<A>) {
        self.transformer = transformer
        super.init(source)
    }
    
    override func state() -> SpinSet<SpinState<A>> {
        return SpinSet(makeState())
    }
    
    override func makeState() -> SpinState<A> {
        return SpinState(getStamp(), transformer(source.toTry()))
    }
    
}
