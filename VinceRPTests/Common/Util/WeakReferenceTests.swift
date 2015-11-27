//
// Created by Viktor Belenyesi on 20/04/15.
// Copyright (c) 2015 Viktor Belenyesi. All rights reserved.
//

@testable import VinceRP

import Quick
import Nimble

let v = AtomicLong(2)

class WeakReferenceSpec: QuickSpec {

    override func spec() {

        context("value") {

            it("does not hold it's value") {
                // when
                let wr = WeakReference(AtomicLong(2))

                // then
                expect(wr.value).to(beNil())
            }

            it("keeps it's value if it got hold outside") {
                // when
                let wr = WeakReference(v)

                // then
                expect(wr.value) == v
            }

        }

    }

}
