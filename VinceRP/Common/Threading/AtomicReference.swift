//
// Created by Viktor Belenyesi on 18/04/15.
// Copyright (c) 2015 Viktor Belenyesi. All rights reserved.
//

class AtomicReference<T> {
    
    private let lock = Spinlock()
    
    private var _value: T
<<<<<<< Updated upstream
    
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
    
    init(_ value: T) {
        _value = value
    }
    
}
=======
    private let lock : UnsafeMutablePointer<pthread_mutex_t>
    
    public var value: T {
        get {
            pthread_mutex_lock(self.lock)
            let value = _value
            pthread_mutex_unlock(self.lock)
            return value
        }
        set {
            pthread_mutex_lock(self.lock)
            _value = newValue
            pthread_mutex_unlock(self.lock)
        }
    }

    public init(_ value: T) {
        self.lock = UnsafeMutablePointer.alloc(sizeof(pthread_mutex_t))
        
        pthread_mutex_init(self.lock, nil)
        _value = value
    }

  }
>>>>>>> Stashed changes
