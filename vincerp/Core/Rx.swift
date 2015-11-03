//
// Created by Viktor Belenyesi on 27/09/15.
// Copyright (c) 2015 Viktor Belenyesi. All rights reserved.
//

public class Rx<T:Equatable>: Reactor {
    
    var dispatchQueue: dispatch_queue_t!
    
    func currentValue() -> T {
        switch (toTry()) {
        case .Success(let box): return box.value
        case .Failure(let error): NSException(name:"name", reason:"domain", userInfo:["error":error]).raise()
        }
        fatalError(UNREACHABLE_CODE)
    }
    
    override public func error() -> NSError {
        switch (toTry()) {
        case .Failure(let error): return error
        case .Success(_): fatalError(UNREACHABLE_CODE)
        }
        fatalError(UNREACHABLE_CODE)
    }
    
    func now() -> T {
        return currentValue()
    }
    
    public func value() -> T {
        if let (e, d) = globalDynamic.value {
            linkChild(e)
            globalDynamic.value = (e, d.arrayByPrepending(self))
        } else {
            globalDynamic.value = nil
        }
        return currentValue()
    }
    
    func propagate() {
        let mappedTargets = children.map {
            EmitterReactorTuple(self, $0)
        }
        guard let q = dispatchQueue else {
            ImmediatePropagator().propagate(mappedTargets)
            return
        }
        dispatch_async(q) {
            ImmediatePropagator().propagate(mappedTargets)
        }
    }
    
    public func toTry() -> Try<T> {
        fatalError(ABSTRACT_METHOD)
    }
    
    public func killAll() {
        kill()
        descendants.forEach {
            $0.kill()
        }
    }
    
    public func recalc() {
        ImmediatePropagator().propagate(toSet(EmitterReactorTuple(self, self)))
    }
    
    public func onChange(skipInitial: Bool = true, callback: (T) -> ()) -> Rx<T> {
        onChangeDo(self, skipInitial: skipInitial) {
            callback($0)
        }
        return self
    }
    
    public func onError(callback: (NSError) -> ()) -> Rx<T> {
        onErrorDo(self) {
            callback($0)
        }
        return self
    }
    
}

extension Rx: Dispatchable {
    
    public func dispatchOnQueue(dispatchQueue: dispatch_queue_t?) -> Rx<T> {
        self.dispatchQueue = dispatchQueue
        return self
    }
    
}

extension Rx {
    
    public func throttle(interval: NSTimeInterval) -> Rx<T> {
        return Throttle(source: self, interval: interval)
    }
    
    public func ignore(ignorabeValues: T) -> Rx<T> {
        return self.filter { $0 != ignorabeValues }
    }
    
}
