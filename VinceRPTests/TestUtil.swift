//
// Created by Viktor Belenyesi on 09/05/15.
// Copyright (c) 2015 Viktor Belenyesi. All rights reserved.
//

@testable import VinceRP

import Quick
import Nimble

infix operator =~ { associativity left precedence 130 }

func =~<T: Equatable> (left: Expectation<T>, right: T?) -> Void {
    return left.toEventually(equal(right))
}

func =~<T: Equatable> (left: Expectation<[T]>, right: [T]?) -> Void {
    return left.toEventually(equal(right))
}

public func testGraph() -> (Source<Int>, Source<Int>, Dynamic<Int>, Dynamic<Int>, Dynamic<Int>, Dynamic<Int>) {
    let n1 = reactive(1)
    let n2 = reactive(2)

    let n3 = definedAs { n1* * n2* }
    let n4 = definedAs { n3* + 5 }
    let n5 = definedAs { n3* / 2 }
    let n6 = definedAs { n4* - n5* + 4 }

    return (n1, n2, n3, n4, n5, n6)
}

class Runnable {
    typealias Closure = () -> ()
    let closure: Closure
    let name: String
    
    init(_ name:String, _ closure: Closure) {
        self.name = name
        self.closure = closure
    }
    
    @objc func run() {
        NSThread.currentThread().name = self.name
        self.closure()
    }
    
    func start() {
        let thread = NSThread(target:self, selector:"run", object:nil)
        thread.start()
    }
}

class Foo: AnyObject, Hashable {
    
    let hashValue: Int
    
    init(hashValue: Int = 1) {
        self.hashValue = hashValue
    }
    
}

class FooReactive: NSObject {
    
    let v: Int
    
    var name: String
    
    init(hashValue: Int = 1) {
        self.v = hashValue
        self.name = "test"
    }
    
    override var hash: Int {
        return self.v
    }
    
}

class ObservableFooReactive: FooReactive {
    var hasObserver = false
    
    override func addObserver(observer: NSObject, forKeyPath keyPath: String, options: NSKeyValueObservingOptions, context: UnsafeMutablePointer<Void>) {
        hasObserver = true
        super.addObserver(observer, forKeyPath: keyPath, options: options, context: context)
    }
    
    override func removeObserver(observer: NSObject, forKeyPath keyPath: String) {
        hasObserver = false
        super.removeObserver(observer, forKeyPath: keyPath)
    }
}

func ==(lhs: Foo, rhs: Foo) -> Bool {
    return lhs.hashValue == rhs.hashValue
}
