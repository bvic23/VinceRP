//
// Created by Viktor Belenyesi on 18/09/15.
// Copyright (c) 2015 Viktor Belenyesi. All rights reserved.
//

@testable import VinceRP

import Quick
import Nimble

class AddableSpec: QuickSpec {
    
    override func spec() {
        
        describe("basic") {
            
            it("works") {
                // given
                let left = reactive(1)
                
                // when
                left += 2
                
                // then
                expect(left*) == 3
            }
            
        }
        
    }
    
}
