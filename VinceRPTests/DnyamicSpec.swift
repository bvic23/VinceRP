//
// Created by Viktor Belenyesi on 12/22/15.
// Copyright (c) 2015 Viktor Belenyesi. All rights reserved.
//

@testable import VinceRP

import Quick
import Nimble

class AAADynamicSpec: QuickSpec {
    
    override func spec() {
        
        context("ping") {

            it("pings empty Set if incoming does not contains self and intersect is empty") {
                // given
                let d = Dynamic(calc: { 1 })
                let e = definedAs {
                    d* + 2
                }
                let c = reactive("")
                d.state = UpdateState(toSet(d), 0, 1, Try(fakeError))

                // when
                let r = d.ping(toSet(c))
                
                // then
                expect(r).to(beEmpty())
            }
            
            it("pings not empty Set if incoming contains self") {
                // given
                let d = Dynamic(calc: { 1 })
                let e = definedAs {
                    d* + 2
                }
                
                // when
                let r = d.ping(toSet(d))
                
                // then
                expect(r).toNot(beEmpty())
            }
            
            it("pings not empty Set if intersect is not empty") {
                // given
                let d = Dynamic(calc: { 1 })
                let e = definedAs {
                    d* + 2
                }
                d.state = UpdateState(toSet(e), 0, 1, Try(fakeError))
                
                // when
                let r = d.ping(toSet(e))
                
                // then
                expect(r).toNot(beEmpty())
            }
            
        }
        
    }
    
}
