//
// Created by Viktor Belenyesi on 11/26/15.
// Copyright (c) 2015 Viktor Belenyesi. All rights reserved.
//

@testable import VinceRP

import Quick
import Nimble

class HubOperatorsSpec: QuickSpec {
    
    override func spec() {
        
        it("should negate") {
            // given
            let x = reactive(true)
            
            // when
            expect(x.value()) == true
            
            // then
            expect(x.not()*) == false
        }
        
        it("can skip errors") {
            // given
            let x = reactive(1)
            let y = definedAs { x* + 1 }.skipErrors()
            var count = 0
            onErrorDo(y) {  _ in
                count++
            }
            
            // when
            x <- fakeError
            
            // then
            expect(count) == 0
        }
        
        it("works with foreach") {
            // given
            let x = reactive(1)
            var history = [Int]()
            
            // when
            x.foreach {
                history.append(2 * $0)
            }
            
            // then
            expect(history) =~ [2]

            // when
            x <- 2
            
            // then
            expect(history) =~ [2, 4]
        }
        
        it("distincts the same elements") {
            // given
            let x = reactive(1)
            let y = x.distinct()
            var c = 0
            y.onChange(skipInitial: true) { _ in
                c++
            }
            
            // when
            x <- 1
            x <- 1
            
            // then
            expect(c) =~ 0
            
            // when
            x <- 2
            
            // then
            expect(c) =~ 1
            
            // when
            x <- 2
            x <- 1
            x <- 2

            // then
            expect(c) =~ 3
        }
        
        it("distincts errors") {
            // given
            let x = reactive(1)
            let y = x.distinct().skipErrors()
            var c = 0
            y.onChange(skipInitial: true) { _ in
                c++
            }
            
            // when
            x <- 1
            x <- 1
            
            // then
            expect(c) =~ 0
            
            // when
            x <- fakeError
            
            // then
            expect(c) =~ 0
            
            // when
            x <- 2
            x <- 1
            x <- 2
            
            // then
            expect(c) =~ 3
        }
        
        it("can ignore specific values") {
            // given
            let x = reactive(1)
            let y = x.ignore(2)
            var count = 0
            y.onChange(skipInitial: true) {  _ in
                count++
            }
            
            // when
            x <- 2
            
            // then
            expect(count) =~ 0

            // when
            x <- 3
            
            // then
            expect(count) =~ 1
        }
        
        it("is dispatchable") {
            // given
            let x = reactive(1)
            let y = definedAs {
                x* + 2
            }.dispatchOnCurrentQueue()

            // when
            x <- 2
            
            // then
            expect(y*) =~ 4
        }
        
    }
    
}
