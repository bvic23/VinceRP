//
// Created by Viktor Belenyesi on 18/04/15.
// Copyright (c) 2015 Viktor Belenyesi. All rights reserved.
//

import vincerp

import Quick
import Nimble

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

class DynamicVariableSpec: QuickSpec {

    override func spec() {

        describe("dynamic variable") {

            var dyn: DynamicVariable<Int>!
            var doSomething: (() -> String)!
            var r1: String!
            var r2: String!

            beforeEach {
                dyn = DynamicVariable(0)
                doSomething = {
                    guard let v = dyn.value else {
                        return ""
                    }
                    return "\(NSThread.currentThread().name!): \(v)"
                }
                r1 = nil
                r2 = nil
                
            }

            it("ensures the different context for different threads") {
                // when
                Runnable("thread-1") {
                    r1 = dyn.withValue(10, doSomething)
                }.start()

                Runnable("thread-2") {
                    r2 = dyn.withValue(20, doSomething)
                }.start()

                // then
                expect(r1).toEventually(equal("thread-1: 10"))
                expect(r2).toEventually(equal("thread-2: 20"))
            }

            it("shares the same variable in same thread") {
                // when
                 Runnable("thread-1") {
                    r1 = dyn.withValue(10, doSomething)
                    r2 = dyn.withValue(20, doSomething)
                }.start()

                // then
                expect(r1).toEventually(equal("thread-1: 10"))
                expect(r2).toEventually(equal("thread-1: 20"))
            }

            // This test does not pass since there is no hiearchy between NSThreads
            // So you cannot inherit the parent thread's dynvalue :-(
            // That is the difference between ThreadLocal and InheritedThreadLocal

            /*
            it("passes the value to the embedded thread") {
                // when
                dyn.withValue(10) { () -> String in
                    Runnable("thread-1") {
                        r1 = doSomething()
                    }.start()
                    Runnable("thread-2") {
                        r2 = doSomething()
                    }.start()
                    return ""
                }
                
                // then
                expect(r1).toEventually(equal("thread-1: 10"))
                expect(r2).toEventually(equal("thread-2: 10"))
            }
            */
        }

    }

}
