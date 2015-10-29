//
// Created by Viktor Belenyesi on 18/04/15.
// Copyright (c) 2015 Viktor Belenyesi. All rights reserved.
//
// Inspired by
// http://www.scala-lang.org/api/2.11.5/index.html#scala.util.DynamicVariable
// and
// https://searchcode.com/codesearch/view/18473763/
// and
// http://scalageek.blogspot.hu/2013/02/when-to-use-dynamic-variables.html?m=1

public class DynamicVariable<T> {

    private let threadLocal: ThreadLocal<T>

    public var value: T? {
        set {
            threadLocal.value = newValue
        }
        get {
            return threadLocal.value
        }
    }

    public init(_ value: T?) {
        self.threadLocal = ThreadLocal(value: value)
        self.value = value
    }

    public func withValue<S>(newval: T, _ thunk: () -> S) -> S {
        let oldval = value

        // set the context
        self.value = newval

        let result = thunk()

        // restore the context
        self.value = oldval

        return result
    }
    
}
