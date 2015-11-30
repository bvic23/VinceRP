//
// Created by Viktor Belenyesi on 19/04/15.
// Copyright (c) 2015 Viktor Belenyesi. All rights reserved.
//

public class AtomicReference<T: AnyObject> {

    private let lock = Spinlock()
    
    private var _value: T

    var value: T {
        
        get {
            return self.lock.around {
                self._value
            }
        }
        
        set(value) {
            self.lock.around {
                self._value = value
            }
        }
    }
    
    public init(_ value: T) {
        _value = value
    }

    public func getAndSet(newValue: T) -> T {
        let result = self.value
        self.value = newValue
        return result
    }
    
    public func compareAndSet(oldValue: T, _ newValue: T) -> Bool {
        self.value = newValue
        return true
    }

}
