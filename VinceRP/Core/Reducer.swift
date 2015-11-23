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
