//
// Created by Viktor Belenyesi on 20/04/15.
// Copyright (c) 2015 Viktor Belenyesi. All rights reserved.
//

@testable import vincerp

import Quick
import Nimble

struct TestFailure {
    static let error = NSError(domain:"Wrappers Tests", code:100, userInfo:[NSLocalizedDescriptionKey:"Testing"])
}

class TrySpec: QuickSpec {

    override func spec() {

        describe("basic") {

            it("maps error to non-success") {
                // when
                let result = Try(false)

                // then
                expect(result.isSuccess()) == true
            }

            it("maps false to non-failure") {
                // when
                let result = Try(false)

                // then
                expect(result.isFailure()) == false
            }


            it("maps error to failure") {
                // when
                let result = Try<Bool>(TestFailure.error)

                // then
                expect(result.isFailure()) == true
            }

            it("maps false to success") {
                // when
                let result = Try<Bool>(TestFailure.error)

                // then
                expect(result.isSuccess()) == false
            }

        }

    }

}
