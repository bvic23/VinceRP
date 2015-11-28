//
// Created by Viktor Belenyesi on 11/27/15.
// Copyright (c) 2015 Viktor Belenyesi. All rights reserved.
//

@testable import VinceRP

import Quick
import Nimble

class MapperSpec: QuickSpec {
    
    override func spec() {
        
        it("can map values") {
            // given
            let x = reactive(10)
            let y = definedAs { x* + 2 }
            let z = x.map { $0 * 2 }
            let s = y.map { $0 + 3 }
            
            // then
            expect(z*) == 20
            expect(s*) == 15
            
            // when
            x <- 1
            
            // then
            expect(z*) == 2
            expect(s*) == 6
        }
        
        it("handles division by zero") {
            // given
            let numerator = reactive(4)
            let denominator = reactive(1)
            
            let frac = definedAs {
                (numerator*, denominator*)
            }.mapAll { (p:Try<(Int, Int)>) -> Try<Int> in
                switch p {
                    case .Success(let box):
                        let (n, d) = box.value
                        if d == 0 {
                            return Try(NSError(domain: "division by zero", code: -0, userInfo: nil))
                        }
                        return Try(n/d)
                    case .Failure(let error): return Try(error)
                }
            }
            
            // when
            denominator <- 0
            
            // then
            expect(frac.toTry().isFailure()) == true

            // when
            denominator <- 2
            
            // then
            expect(frac*) == 2

        }
        
    }
    
}
