//
// Created by Viktor Belenyesi on 22/04/15.
// Copyright (c) 2015 Viktor Belenyesi. All rights reserved.
//

@testable import vincerp

import Quick
import Nimble

class Foo : Equatable {
    let i: Int
    init(_ i: Int) {
        self.i = i
    }
}

func ==(lhs: Foo, rhs: Foo) -> Bool {
    return lhs.i == rhs.i
}

class AtomicReferenceSpec: QuickSpec {

    override func spec() {

        describe("default") {

            it("should have all the normal operations") {
                // given
                let thing1 = Foo(5)
                let thing1bis = Foo(5) // equals(), but not the same reference
                let thing2 = Foo(10)

                // when
                let atomic = AtomicReference(thing1)

                // then
                expect(atomic.value) == thing1
                atomic.value = thing2

                expect(atomic.value) == thing2
                expect(atomic.compareAndSet(thing1, thing1)) == false

                expect(atomic.value) == thing2
                expect(atomic.compareAndSet(thing2, thing1)) == true

                expect(atomic.value) == thing1
                expect(atomic.compareAndSet(thing1bis, thing2)) == false

                expect(atomic.getAndSet(thing2)) == thing1
                expect(atomic.value) == thing2
            }

        }

    }

}
