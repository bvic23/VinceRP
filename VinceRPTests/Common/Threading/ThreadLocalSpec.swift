//
// Created by Viktor Belenyesi on 12/21/15.
// Copyright (c) 2015 Viktor Belenyesi. All rights reserved.
//

@testable import VinceRP

import Quick
import Nimble

class ThreadLocalSpec: QuickSpec {
    
    override func spec() {
        
        describe("same thread") {
            
            var t: ThreadLocal<Int>!
            
            beforeEach {
                // given
                t = ThreadLocal(key: "k1", value: 1)
            }
            
            it("stores the value") {
                // then
                expect(t.value) =~ 1
            }
            
            it("can nil the value") {
                // when
                t.value = nil
                
                // then
                expect(t.value).toEventually(beNil())
            }
            
            it("can store multiple values on same thread") {
                // given
                let t2 = ThreadLocal(key: "k2", value: 2)
                
                // when
                t.value = 3
                
                // then
                expect(t.value) =~ 3
                expect(t2.value) =~ 2
            }
            
            it("refers to the same variable with the same name on the same thread") {
                // when
                let t2 = ThreadLocal(key: "k1", value: 2)
                
                // then
                expect(t.value) =~ 2
                expect(t2.value) =~ 2
            }
        
        }
        
        describe("multi thread") {
            
            var r1: Int!
            var r2: Int!
            
            it("can have different variables on different threads with the same name") {
                // when
                Runnable("thread-1") {
                    let t1 = ThreadLocal(key: "key1", value: 1)
                    r1 = t1.value
                }.start()
                
                Runnable("thread-2") {
                    let t2 = ThreadLocal(key: "key2", value: 2)
                    r2 = t2.value
                }.start()
                
                // then
                expect(r1) =~ 1
                expect(r2) =~ 2
            }
            
        }
        
    }
    
}
