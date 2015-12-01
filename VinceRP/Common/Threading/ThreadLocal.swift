//
// Created by Viktor Belenyesi on 18/04/15.
// Copyright (c) 2015 Viktor Belenyesi. All rights reserved.
//

final class Box<T> {
    
    var value: T
    
    init(_ value: T) {
        self.value = value
    }
    
}

public class ThreadLocal<T> {
    
    private let key: NSString

    public init(value: T?, key: NSString) {
        self.key = key
        self.value = value
    }

    public var value: T? {
        set {
            if let v = newValue {
                NSThread.currentThread().threadDictionary[key] = Box(v)
            } else {
                // TODO: add test
                NSThread.currentThread().threadDictionary.removeObjectForKey(key)
            }
        }
        get {
            guard let r: Box<T> = NSThread.currentThread().threadDictionary[key] as? Box<T> else {
                return nil
            }
            return r.value
        }
    }

}
