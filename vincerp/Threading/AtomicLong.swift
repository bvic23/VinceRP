//
// Created by Viktor Belenyesi on 18/04/15.
// Copyright (c) 2015 Viktor Belenyesi. All rights reserved.
//

public typealias long = Int32

public class AtomicLong: Hashable, Equatable {
    private let pointer: UnsafeMutablePointer<long> = UnsafeMutablePointer < long>.alloc(1)

    public var value: long {
        get {
            OSMemoryBarrier()
            return pointer.memory
        }
        set {
            getAndSet(newValue)
        }
    }

    public init(_ value: long) {
        pointer.memory = value
    }

    deinit {
        pointer.destroy()
    }

    public func getAndSet(newValue: long) -> long {
        while (true) {
            let current = value
            if compareAndSet(current, newValue) {
                return current
            }
        }
    }

    public func compareAndSet(expected: long, _ newValue: long) -> Bool {
        return OSAtomicCompareAndSwap32Barrier(expected, newValue, pointer)
    }

    public func getAndAdd(newValue: long) -> long {
        while (true) {
            let current = value
            let next = current + newValue
            if compareAndSet(current, next) {
                return current
            }
        }
    }

    public func addAndGet(value: long) -> long {
        return OSAtomicAdd32Barrier(value, pointer)
    }

    public func getAndIncrement() -> long {
        return getAndAdd(1)
    }

    public func getAndDecrement() -> long {
        return getAndAdd(-1)
    }

    public func incrementAndGet() -> long {
        return addAndGet(1)
    }

    public func decrementAndGet() -> long {
        return addAndGet(-1)
    }

    public var hashValue: Int {
        get {
            return value.hashValue
        }
    }
}

public func ==(lhs: AtomicLong, rhs: AtomicLong) -> Bool {
    return lhs.value == rhs.value
}
