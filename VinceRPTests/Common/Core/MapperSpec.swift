//
//  Created by Viktor Belenyesi on 11/27/15.
//  Copyright © 2015 Viktor Belenyesi. All rights reserved.
//

@testable import VinceRP

import Quick
import Nimble

class MapperSpec: QuickSpec {
    
    override func spec() {
        
        it("can map values") {
            // given
            let a = reactive(10)
            let b = definedAs { a* + 2 }
            let c = a.map { $0 * 2 }
            let d = b.map { $0 + 3 }
            
            // then
            expect(c*) == 20
            expect(d*) == 15
            
            // when
            a <- 1
            
            // then
            expect(c*) == 2
            expect(d*) == 6
        }
        
        it("handles division by zero") {
            // given
            let numerator = reactive(4)
            let denominator = reactive(1)
            
            let frac = definedAs {
                [numerator*, denominator*]
            }.mapAll { (p:Try<[Int]>) -> Try<Int> in
                switch p {
                    case .Success(let tuple):
                        let n = tuple.value[0]
                        let d = tuple.value[1]
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