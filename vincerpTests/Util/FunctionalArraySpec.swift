//
// Created by Viktor Belenyesi on 21/04/15.
// Copyright (c) 2015 Viktor Belenyesi. All rights reserved.
//

import Quick
import Nimble

class FunctionalArraySpec: QuickSpec {

    override func spec() {

        describe("prepend") {

            it("prepends to non-empty array") {
                // given
                let s = [1, 2]

                // when
                let r = s.prepend(0)

                // then
                expect(r) == [0, 1, 2]
            }

            it("prepends to empty array") {
                // given
                let s = [Int]()

                // when
                let r = s.prepend(0)

                // then
                expect(r) == [0]
            }
            
        }

    }

}
