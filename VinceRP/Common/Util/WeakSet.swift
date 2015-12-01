//
// Created by Viktor Belenyesi on 18/04/15.
// Copyright (c) 2015 Viktor Belenyesi. All rights reserved.
//

public class WeakSet<T: Hashable where T: AnyObject> {
    private var _array: [WeakReference<T>]
    private let lock = Spinlock()
    
    public init() {
        _array = Array()
    }

    public init(_ array: [T]) {
        self._array = array.map {
            WeakReference($0)
        }
    }
    
    public var set: Set<T> {
        return Set(self.array())
    }

    public func insert(member: T) {
        lock.around {
            var found = false
            for e in self._array {
                if e.hashValue == member.hashValue {
                    found = true
                    break
                }
            }
            if !found {
                self._array.append(WeakReference(member))
            }
        }
    }

    public func filter(@noescape includeElement: (T) -> Bool) -> WeakSet<T> {
        return WeakSet(self.array().filter(includeElement))
    }

    public func hasElementPassingTest(@noescape filterFunc: (T) -> Bool) -> Bool {
        return self.array().hasElementPassingTest(filterFunc)
    }

    public func map<U>(@noescape transform: (T) -> U) -> WeakSet<U> {
        return WeakSet<U>(self.array().map(transform))
    }
    
    public func flatMap<U>(@noescape transform: (T) -> U?) -> WeakSet<U> {
        return WeakSet<U>(self.array().flatMap(transform))
    }
    
    private func array() -> Array<T> {
        return lock.around {
            return self._array.filter {
                $0.value != nil
            }.map {
                $0.value!
            }
        }

    }

}
