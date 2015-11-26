//
// Created by Viktor Belenyesi on 11/26/15.
// Copyright (c) 2015 Viktor Belenyesi. All rights reserved.
//

@testable import VinceRP

import Quick
import Nimble

class HubOperatorsSpec: QuickSpec {
    
    override func spec() {
        
        describe("not") {
            
            it("should negate") {
                // given
                let a = reactive(true)
                
                // when
                expect(a.value()) == true
                
                // then
                expect(a.not()*) == false
            }
            
        }
        
    }
    
}
