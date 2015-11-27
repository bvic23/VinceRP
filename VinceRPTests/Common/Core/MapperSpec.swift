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
        
        it("can map all values") {
            // given
            let a = reactive(10)
            let b = definedAs { 100 / a* }
            let c = b.mapAll { (p:Try<Int>) -> Try<Int> in
                switch p {
                case .Success(let box): return Try(box.value * 2)
                default: return Try(1337)
                }
            }
            let d = b.mapAll { (p:Try<Int>) -> Try<String> in
                switch p {
                case .Success( _): return Try(fakeError)
                case .Failure(let w): return Try(w.description)
                }
            }
            
            // then
            expect(c*) == 20
            expect(d.toTry().isFailure()) == true
            
            // when
            a <- fakeError
            
            // then
            expect(c*) == 1337
            expect(d.toTry().isSuccess()) == true
        }
        
    }
    
}