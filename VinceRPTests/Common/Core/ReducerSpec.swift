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
            let y = definedAs { 100 / x* }
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
        
        it("reduces") {
            // given
            let x = reactive(1)
            let y = x.reduce { $0 * $1 }
            
            // when
            x <- 2
            expect(y*) == 2
            
            // when
            x <- 3
            expect(y*) == 6
            
            // when
            x <- 4
            expect(y*) == 24
        }
        
        it("reduces all") {
            // given
            let x = reactive(1)
            let y = definedAs { 100 / x* }
            let z = y.reduceAll { (x, y) in
                switch (x, y) {
                case (.Success(let a), .Success(let b)): return Try(a.value + b.value)
                case (.Failure(_), .Failure(_)): return Try(1337)
                case (.Failure(let a), .Success(_)): return .Failure(a)
                case (.Success(_), .Failure(let b)): return .Failure(b)
                }
            }
            
            // then
            expect(z*) == 100
            
            // when
            x <- fakeError
            
            // then
            expect(z.toTry().isFailure()) == true
            
            // when
            x <- 10
            
            // then
            expect(z.toTry().isFailure()) == true
            
            // when
            x <- 100
            
            // then
            expect(z.toTry().isFailure()) == true
            
            // when
            x <- fakeError
            
            // then
            expect(z*) == 1337
            
            // when
            x <- 10
            
            // then
            expect(z*) == 1347
        }
        
    }
    
}