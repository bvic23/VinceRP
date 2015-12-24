//
// Created by Viktor Belenyesi on 12/24/15.
// Copyright (c) 2015 Viktor Belenyesi. All rights reserved.
//

@testable import VinceRP

import Quick
import Nimble

class IncrementingSpec: QuickSpec {
    
    override func spec() {
        
        it("makes empty state") {
            // given
            let sut: Incrementing<Int> = Incrementing()
            
            // when
            let r = sut.makeState()
            
            // then
            expect(r.value.isFailure()) == true
            expect(r.value.description) == noValueError.description
        }
        
    }
    
}