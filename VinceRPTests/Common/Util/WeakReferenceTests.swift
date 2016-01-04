//
// Created by Viktor Belenyesi on 20/04/15.
// Copyright (c) 2015 Viktor Belenyesi. All rights reserved.
//

@testable import VinceRP

import Quick
import Nimble

let v = NSObject()

class Foo: Hashable {
    let hashValue = 5
}

func ==(lhs: Foo, rhs: Foo) -> Bool {
    return lhs.hashValue == rhs.hashValue
}

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
        
        describe("hash") {

            it("'s hash is not 0 if reference is valid") {
                // when
                let wr = WeakReference(v)
                
                // then
                expect(wr.hashValue) != 0
            }

            it("'s hash is 0 if reference is gone") {
                // when
                let wr = WeakReference(NSObject())
                
                // then
                expect(wr.hashValue) == 0
            }
            
        }
        
        describe("equality") {
            
            it("holds equality for same instances") {
                // when
                let w1 = WeakReference(v)
                let w2 = WeakReference(v)
                
                // then
                expect(w1) == w2
            }
            
            it("holds equality for nil reference") {
                // when
                let w1 = WeakReference(NSObject())
                let w2 = WeakReference(NSObject())
                
                // then
                expect(w1) == w2
                expect(w1.hashValue) == 0
            }
            
            it("holds equality the same hasValue") {
                // when
                let w1 = WeakReference(Foo())
                let w2 = WeakReference(Foo())
                
                // then
                expect(w1) == w2
            }
            
        }

    }

}
