//
// Created by Viktor Belenyesi on 20/04/15.
// Copyright (c) 2015 Viktor Belenyesi. All rights reserved.
//

@testable import VinceRP

import Quick
import Nimble

let v = NSObject()

class WeakReferenceSpec: QuickSpec {

    override func spec() {

        context("value") {

            it("does not hold it's value") {
                // when
                let wr = WeakReference(NSObject())

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
