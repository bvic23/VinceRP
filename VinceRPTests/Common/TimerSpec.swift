//
// Created by Viktor Belenyesi on 12/22/15.
// Copyright (c) 2015 Viktor Belenyesi. All rights reserved.
//

@testable import VinceRP

import Quick
import Nimble

class TimerSpec: QuickSpec {
    
    override func spec() {
        
        describe("basic") {
            
            var t: Timer!
            var counter = 0
            
            beforeEach {
                // given
                counter = 0
                t = timer(0.01) {
                    counter++
                }
            }
            
            afterEach {
                t.cancel()
            }
            
            it("works") {
                // then
                expect(counter).toEventually(beGreaterThan(0))
            }
            
            it("is cancellable") {
                // when
                t.cancel()
                
                // then
                expect(counter).toEventually(equal(0))
            }
            
            it("is cancellable twice without a problem") {
                // when
                t.cancel()
                t.cancel()
                
                // then
                expect(counter).toEventually(equal(0))
            }
        }
        
    }
    
}
