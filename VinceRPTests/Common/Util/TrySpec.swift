//
// Created by Viktor Belenyesi on 20/04/15.
// Copyright (c) 2015 Viktor Belenyesi. All rights reserved.
//

@testable import VinceRP

import Quick
import Nimble

class TrySpec: QuickSpec {

    override func spec() {

        describe("basic") {

            it("successful for non-error") {
                // when
                let result = Try(false)

                // then
                expect(result.isSuccess()) == true
            }

            it("is not failure for non-error") {
                // when
                let result = Try(false)

                // then
                expect(result.isFailure()) == false
            }

            it("is failure for error") {
                // when
                let result = Try<Bool>(fakeError)

                // then
                expect(result.isFailure()) == true
            }

            it("is not successful for error") {
                // when
                let result = Try<Bool>(fakeError)

                // then
                expect(result.isSuccess()) == false
            }

        }
        
        describe("map") {
            
            it("maps error to error") {
                // given
                let a = Try<Int>(fakeError)
                
                // when
                let result = a.map { $0 * 2 }
                
                // then
                expect(result.isFailure()) == true
                expect(result.description) == fakeError.description
            }
            
            it("maps non-error correctly") {
                // given
                let a = Try(2)
                
                // when
                let result = a.map { $0 * 2 }
                
                // then
                expect(result.isSuccess()) == true
                expect(result.description) == "4"
            }
            
        }

    }

}
