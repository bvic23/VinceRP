//
// Created by Viktor Belenyesi on 12/24/15.
// Copyright (c) 2015 Viktor Belenyesi. All rights reserved.
//

@testable import VinceRP

import Quick
import Nimble

class NodeSpec: QuickSpec {
    
    override func spec() {
        
        it("responds with empty set to ping") {
            // given
            let sut = Node()
            
            // when
            let r = sut.ping(Set())
            
            // then
            expect(r).toEventually(beEmpty())
        }
        
        it("responds with empty set to ping even if incoming is not empty") {
            // given
            let sut = Node()
            
            // when
            let r = sut.ping(toSet(Node()))
            
            // then
            expect(r).toEventually(beEmpty())
        }
    }
    
}