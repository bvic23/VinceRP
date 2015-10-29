//
// Created by Viktor Belenyesi on 18/04/15.
// Copyright (c) 2015 Viktor Belenyesi. All rights reserved.
//

public class ThreadLocal<T> {
    private let threadLocalKey = "threadLocal" as NSString

    public init(value: T?) {
        self.value = value
    }

    public var value: T? {
        set {
            if let v = newValue {
                NSThread.currentThread().threadDictionary[threadLocalKey] = Box(v)
            }
        }
        get {
            guard let r: Box<T> = NSThread.currentThread().threadDictionary[threadLocalKey] as? Box<T> else {
                return nil
            }
            return r.value
        }
    }

}
