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
            dispatch_async(dispatch_get_main_queue()) {
                expect(y*) =~ 1                
            }
        }
        
    }
    
}