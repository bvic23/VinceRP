//
// Created by Viktor Belenyesi on 27/09/15.
// Copyright (c) 2015 Viktor Belenyesi. All rights reserved.
//

public class Hub<T>: Node {
    
    var dispatchQueue: dispatch_queue_t!
    
    func currentValue() -> T {
        switch (toTry()) {
        case .Success(let value): return value
        case .Failure(let error): NSException(name:"name", reason:"domain", userInfo:["error":error]).raise()
        }
        unreachableCode()
    }
    
    override public func error() -> NSError {
        switch (toTry()) {
        case .Failure(let error): return error
        case .Success(_): unreachableCode()
        }
        unreachableCode()
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
        Propagator.dispatch {
            let mappedTargets = self.children.map {
                NodeTuple(self, $0)
            }
            Propagator.propagate(mappedTargets)
        }
    }
    
    public func toTry() -> Try<T> {
        abstractMethod()
    }
    
    public func killAll() {
        kill()
        descendants.forEach {
            $0.kill()
        }
    }
    
    public func recalc() {
        Propagator.propagate(toSet(NodeTuple(self, self)))
    }
    
    public func onChange(skipInitial skipInitial: Bool = true, callback: (T) -> ()) -> ChangeObserver {
        return onChangeDo(self, skipInitial: skipInitial) {
            callback($0)
        }
    }
    
    public func onError(callback: (NSError) -> ()) -> ErrorObserver {
        return onErrorDo(self) {
            callback($0)
        }
    }
    
}

extension Hub: Dispatchable {
    
    public func dispatchOnQueue(dispatchQueue: dispatch_queue_t?) -> Hub<T> {
        self.dispatchQueue = dispatchQueue
        return self
    }
    
}
