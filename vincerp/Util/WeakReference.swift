//
// Created by Viktor Belenyesi on 21/04/15.
// Copyright (c) 2015 Viktor Belenyesi. All rights reserved.
//
// https://github.com/scala/scala/blob/2.11.x/src/library/scala/ref/WeakReference.scala

public class WeakReference<T:AnyObject where T:Hashable>: Hashable, Equatable {
    public weak var value: T?

    public init(_ value: T) {
        self.value = value
    }

    public var hashValue: Int {
        guard let v = self.value else {
            return 0
        }
        return v.hashValue
    }
}

public func ==<T>(lhs: WeakReference<T>, rhs: WeakReference<T>) -> Bool {
    return lhs.hashValue == rhs.hashValue
}
