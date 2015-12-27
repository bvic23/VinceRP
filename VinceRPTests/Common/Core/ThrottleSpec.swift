//
// Created by Viktor Belenyesi on 11/27/15.
// Copyright (c) 2015 Viktor Belenyesi. All rights reserved.
//

@testable import VinceRP

import Quick
import Nimble

class ThrottleSpec: QuickSpec {
    
    override func spec() {
        
        it("waits") {
            // given
            let x = reactive(0)
            let y = x.throttle(0.1)

            // then
            expect(y*) =~ 0

            // when
            x <- 1
            
            // then
            expect(y*) =~ 0
            
            // then
            expect(y*) =~ 1
        }
        
        it("invalidates it's timer") {
            // given
            let x = reactive(0)
            let y = Throttle(source: x, interval: 1.0)
            
            // when
            x <- 1
            let t1 = y.getTimer()!
            x <- 2
            let t2 = y.getTimer()!
            
            // then
            expect(t1) != t2
        }
        
        it("propagates") {
            // given
            let x = reactive(0)
            let y = x.throttle(0.1)
            let z = definedAs {
                y* + 2
            }
            
            // then
            expect(y*) =~ 0
            
            // when
            x <- 1
            
            // then
            expect(z*) == 2
            
            // then
            expect(z*) =~ 3
        }
        
    }
    
}