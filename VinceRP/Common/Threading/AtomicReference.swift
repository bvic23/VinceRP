//
// Created by Viktor Belenyesi on 19/04/15.
// Copyright (c) 2015 Viktor Belenyesi. All rights reserved.
//

public class AtomicReference<T: AnyObject> {
    
    private var _value: T
    private let pointer: UnsafeMutablePointer<UnsafeMutablePointer<Void>> = UnsafeMutablePointer.alloc(1)

    public var value: T {
        get {
            OSMemoryBarrier()
            return _value
        }
        set {
            getAndSet(newValue)
        }
    }

    public init(_ value: T) {
        _value = value
        pointer.memory = UnsafeMutablePointer<Void>(Unmanaged.passUnretained(value).toOpaque())
    }

    deinit {
        pointer.destroy()
    }

    public func getAndSet(newValue: T) -> T {
        while (true) {
            let current = value
            if (compareAndSet(current, newValue)) {
                return current
            }
        }
    }

    public func compareAndSet(oldValue: T, _ newValue: T) -> Bool {
        let ov = Unmanaged.passUnretained(oldValue)
        let nv = Unmanaged.passUnretained(newValue)

        guard OSAtomicCompareAndSwapPtrBarrier(UnsafeMutablePointer<Void>(ov.toOpaque()), UnsafeMutablePointer<Void>(nv.toOpaque()), pointer) else {
            return false
        }
        _value = newValue
        return true
    }

}
