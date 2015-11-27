//
// Created by Viktor Belenyesi on 11/27/15.
// Copyright (c) 2015 Viktor Belenyesi. All rights reserved.
//

@testable import VinceRP

import Quick
import Nimble

class ReducerSpec: QuickSpec {
    
    override func spec() {
        
        it("filters") {
            // given
            let x = reactive(10)
            let y = x.filter { $0 > 5 }
            
            // when
            x <- 1
            
            // then
            expect(y*) == 10
            
            // when
            x <- 6
            
            // then
            expect(y*) == 6
            
            // when
            x <- 2
            
            // then
            expect(y*) == 6
            
            // when
            x <- 19
            
            // then
            expect(y*) == 19
        }
        
        it("filters all") {
            // given
            let x = reactive(10)
            let y = definedAs { 100 * x* }
            let z = y.filterAll { $0.isSuccess() }
            
            // then
            expect(z*) == 10
            
            // when
            x <- 9
            
            // then
            expect(z*) == 11
            
            // when
            x <- fakeError
            
            // then
            expect(z*) == 11
            
            // when
            x <- 1
            
            // then
            expect(z*) == 100
        }
        
    }
    
}