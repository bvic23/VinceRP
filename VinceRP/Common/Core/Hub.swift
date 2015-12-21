//
// Created by Viktor Belenyesi on 27/09/15.
// Copyright (c) 2015 Viktor Belenyesi. All rights reserved.
//

public class Hub<T>: Node {
    
    var dispatchQueue: dispatch_queue_t!
    
    func currentValue() -> T {
        if case .Success(let value) = toTry() {
            return value
        }
        if case .Failure(let error) = toTry() {
            NSException(name:"name", reason:"domain", userInfo:["error":error]).raise()
        }
        unreachableCode()
    }
    
    override public func error() -> NSError {
        if case .Failure(let error) = toTry() {
            return error
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
        let mappedTargets = self.children.map {
            NodeTuple(self, $0)
        }
        Propagator.propagate(mappedTargets)
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
        return onChangeDo(self, skipInitial: skipInitial, callback: callback)
    }
    
    public func onError(callback: (NSError) -> ()) -> ErrorObserver {
        return onErrorDo(self, callback: callback)
    }
    
}

extension Hub: Dispatchable {
    
    public func dispatchOnQueue(dispatchQueue: dispatch_queue_t?) -> Hub<T> {
        self.dispatchQueue = dispatchQueue
        return self
    }
    
}
