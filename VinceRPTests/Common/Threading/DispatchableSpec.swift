//
// Created by Viktor Belenyesi on 12/22/15.
// Copyright (c) 2015 Viktor Belenyesi. All rights reserved.
//

@testable import VinceRP

import Quick
import Nimble

class Sut {
    var dispatchQueue: dispatch_queue_t?
}

extension Sut: Dispatchable {
    
    func dispatchOnQueue(dispatchQueue: dispatch_queue_t?) -> Sut {
        self.dispatchQueue = dispatchQueue
        return self
    }

}

class DispatchableSpec: QuickSpec {
    
    override func spec() {
        
        describe("basic") {

            it("dispatches on main queue") {
                // given
                let sut = Sut()
                
                // when
                sut.dispatchOnMainQueue()
                
                // then
                expect(sut.dispatchQueue).to(beIdenticalTo(dispatch_get_main_queue()))
            }
            
            it("dispatches on current queue") {
                // given
                let sut = Sut()
                
                // when
                sut.dispatchOnCurrentQueue()
                
                // then
                expect(sut.dispatchQueue).to(beNil())
            }

            it("dispatches on background queue") {
                // given
                let sut = Sut()
                
                // when
                sut.dispatchOnBackgroundQueue()
                
                // then
                expect(sut.dispatchQueue).notTo(beIdenticalTo(dispatch_get_main_queue()))
                expect(sut.dispatchQueue).notTo(beNil())
            }
            
        }
        
    }
    
}
