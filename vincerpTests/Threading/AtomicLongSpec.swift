//
// Created by Viktor Belenyesi on 20/04/15.
// Copyright (c) 2015 Viktor Belenyesi. All rights reserved.
//

import vincerp

import Quick
import Nimble

class AtomicLongSpec: QuickSpec {
    
    override func spec() {
        
        describe("default") {
            
            it("should have all the normal operations") {
                // given
                let atomic = AtomicLong(10)
                
                // then
                expect(atomic.value) == 10
                
                // when
                atomic.value = 20
                
                // then
                expect(atomic.value) == 20

                expect(atomic.getAndIncrement()) == 20
                expect(atomic.value) == 21

                expect(atomic.getAndDecrement()) == 21
                expect(atomic.value) == 20

                expect(atomic.getAndSet(0)) == 20
                expect(atomic.value) == 0

                expect(atomic.incrementAndGet()) == 1
                expect(atomic.value) == 1

                expect(atomic.decrementAndGet()) == 0
                expect(atomic.value) == 0

                expect(atomic.addAndGet(10)) == 10
                expect(atomic.value) == 10

                expect(atomic.compareAndSet(1, 20)) == false
                expect(atomic.value) == 10

                expect(atomic.compareAndSet(10, 20)) == true
                expect(atomic.value) == 20
            }
            
        }
        
    }
    
}
