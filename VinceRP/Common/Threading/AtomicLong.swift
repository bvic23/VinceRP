//
// Created by Viktor Belenyesi on 18/04/15.
// Copyright (c) 2015 Viktor Belenyesi. All rights reserved.
//

public typealias long = Int32

public class AtomicLong {
    
    private let lock = Spinlock()
    
    private var _value: long
    
    var value: long {
        
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
    
    public init(_ value: long) {
        _value = value
    }

    public func getAndIncrement() -> long {
        let current = value
        self.value = current + 1
        return current
    }
    
}