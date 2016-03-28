//
// Created by Viktor Belenyesi on 18/04/15.
// Copyright (c) 2015 Viktor Belenyesi. All rights reserved.
//

@testable import VinceRP

import Quick
import Nimble

func function(a: Int) -> Int {
    return 3 + a
}

class SmokeSpec: QuickSpec {

    override func spec() {

        describe("basic") {

            context("reactive variable") {
                
                it("holds the initial value") {
                    // given
                    let a = reactive(1)

                    // then
                    expect(a*) =~ 1
                }

                it("updates it's value") {
                    // given
                    let a = reactive(1)

                    // when
                    a <- 6

                    // then
                    expect(a*) =~ 6
                }

                it("updates it's value using double arrow") {
                    // given
                    let a = reactive(1)

                    // when
                    a <- 6 <- 3

                    // then
                    expect(a*) =~ 3
                }

                it("updates it's value from a function") {
                    // given
                    let a = reactive(1)

                    // when
                    a <- function(1)

                    // then
                    expect(a*) =~ 4
                }

            }

            context("reactive hub") {

                it("calculates it's value initially") {
                    // given
                    let a = reactive(1)
                    let b = reactive(2)

                    // when
                    let c = definedAs {
                        a* + b*
                    }

                    // then
                    expect(c*) =~ 3
                }

                it("updates it's value on parent gets update") {
                    
                    // given
                    let a = reactive(1)
                    let b = reactive(2)
                    let c = definedAs {
                        a* + b*
                    }

                    // when
                    a <- 2

                    // then
                    expect(c*) =~ 4
                    
                }

                it("updates it's value on parents get update") {
                    // given
                    let a = reactive(1)
                    let b = reactive(2)
                    let c = definedAs {
                        a* + b*
                    }

                    // when
                    a <- 2
                    b <- 3

                    // then
                    expect(c*) =~ 5
                }

            }

            context("side effect") {

                it("runs sideeffect initially") {
                    // given
                    let a = reactive(1)
                    var counter = 0

                    // when
                    _ = onChangeDo(a) { _ in
                        counter += 1
                    }

                    // then
                    expect(counter) =~ 1
                }

                it("runs sideeffect when parent gets update") {
                    // given
                    let a = reactive(1)
                    
                    var counter = 0
                    _ = onChangeDo(a) { _ in
                        counter += 1
                    }

                    // when
                    a <- 2

                    // then
                    expect(counter) =~ 2
                }

                it("runs sideeffect on hub gets update") {
                    // given
                    let a = reactive(1)
                    let b = reactive(2)
                    let c = definedAs {
                        "test\(a*)+\(b*)"
                    }
                    var counter = 0
                    _ = onChangeDo(c) { _ in
                        counter += 1
                    }

                    // when
                    a <- 8
                    expect(c*) =~ "test8+2"
                    b <- 6

                    // then
                    expect(c*) =~ "test8+6"
                    expect(counter) =~ 3
                }
                
                it("runs sideeffect on complex") {
                    // given
                    let a = reactive(1)
                    let b = reactive(2)
                    let e = reactive("buda")
                    let c = definedAs {
                        "pest=\(a*)+\(b*)"
                    }
                    let f = definedAs {
                        e* + c*
                    }
                    var counter = 0
                    _ = onChangeDo(c) {  _ in
                        counter += 1
                    }
                    
                    // when
                    a <- 8
                    
                    expect(c*) =~ "pest=8+2"
                    
                    b <- 6
                    
                    // then
                    expect(c*) =~ "pest=8+6"
                    expect(f*) =~ "budapest=8+6"
                    expect(counter) =~ 3
                }
                
                it("is happy without default value") {
                    // given
                    let a: Source<Int> = reactive()
                    
                    // then
                    expect(a.hasValue()) =~ false
                    
                    // when
                    a <- 1
                    
                    // then
                    expect(a*) =~ 1
                    expect(a.hasValue()) =~ true
                    
                    // when
                    a <- fakeError
                    
                    // then
                    expect(a.hasValue()) =~ true
                }
                
                it("is works with optionals") {
                    // given
                    let a: Source<Int?> = reactive(1)
                    
                    // then
                    expect(a*) =~ 1
                    
                    // when
                    a <- nil
                    
                    // then
                    expect(a*).to(beNil())
                    
                    // when
                    a <- fakeError
                    
                    // then
                    expect(a.toTry().isFailure()) =~ true
                }                                

            }

        }

    }

}
