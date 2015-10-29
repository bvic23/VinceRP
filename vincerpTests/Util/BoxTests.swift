//
// Created by Viktor Belenyesi on 20/04/15.
// Copyright (c) 2015 Viktor Belenyesi. All rights reserved.
//

import vincerp

import Quick
import Nimble

class BoxSpec: QuickSpec {

    override func spec() {

        describe("basic") {

            it("holds it's value correctly") {
                // when
                let box = Box(1)

                // then
                expect(box.value) == 1
            }

            it("can hold objects as well") {
                // given
                let v = NSObject()

                // when
                let box = Box(v)

                // then
                expect(box.value) == v
            }

        }

    }

}
