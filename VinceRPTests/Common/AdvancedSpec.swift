//
// Created by Viktor Belenyesi on 18/04/15.
// Copyright (c) 2015 Viktor Belenyesi. All rights reserved.
//

@testable import VinceRP

import Quick
import Nimble

func myRandom() -> Int {
    return Int(arc4random())
}

let fakeError = NSError(domain: "domain.com", code: 1, userInfo: nil)

class AdvancedSpec: QuickSpec {

    override func spec() {

        describe("advanced") {
            /*
            context("performance") {

                it("init") {
                    // given
                    let start = CACurrentMediaTime()
                    var n = 0

                    // when
                    while CACurrentMediaTime() < start + 1.0 {
                        let (_, _, _, _, _, _) = testGraph()
                        n += 1
                    }

                    // then
                    expect(n) > 30000
                }

                it("propagation") {
                    // given
                    let (a, b, c, d, e, f) = testGraph()
                    let start = CACurrentMediaTime()
                    var n = 0

                    // when
                    while CACurrentMediaTime() < start + 1.0 {
                        a <- n
                        n += 1
                    }

                    // then
                    expect(n) > 9500.0
                }

            }
            */

            context("nesting") {

                it("works with nested reactives") {
                    // given
                    let a = reactive(1)
                    let b = definedAs {
                        (definedAs{ a* },  definedAs{ myRandom() })
                    }
                    let r = b*.1*

                    // when
                    a <- 2

                    // then
                    expect(b*.1*) == r
                }                
                
                it("works with recalcs") {
                    // given
                    var source = 0
                    let a = definedAs{source}
                    var i = 0
                    _ = onChangeDo(a){  _ in
                        i += 1
                    }

                    // then
                    expect(i) == 1
                    expect(a*) == 0

                    // when
                    source = 1

                    // then
                    expect(a*) == 0

                    // when
                    a.recalc()

                    // then
                    expect(a*) == 1
                    expect(i) == 2
                }

                it("can update multiple variables in a batch") {
                    // given
                    let a = reactive(1)
                    let b = reactive(1)
                    let c = reactive(1)
                    let d = definedAs {
                        a* + b* + c*
                    }
                    var i = 0

                    // when
                    _ = onChangeDo(d) {  _ in
                        i += 1
                    }

                    // then
                    expect(i) == 1
                    a <- 2
                    expect(i).toEventually(equal(2))
                    b <- 2
                    expect(i) == 3
                    c <- 2
                    expect(i) == 4

                    BatchUpdate(a, withValue:3).and(b, withValue:3).and(c, withValue:3).now()

                    expect(i) == 5

                    BatchUpdate(a, withValue:4).and(b, withValue:5).and(c, withValue:6).now()

                    expect(i) == 6
                    expect(a*) == 4
                    expect(b*) == 5
                    expect(c*) == 6
                }

            }

        }

        describe("combinators") {

            it("blocks observers") {
                // given
                let a = reactive(10)
                let b = a.filter {
                    $0 > 5
                }
                var sideeffect = 0
                onChangeDo(b) {  _ in
                    sideeffect = sideeffect + 1
                }
                
                // when
                a <- 1
                
                // then
                expect(b*) == 10
                expect(sideeffect) == 1
                
                // when
                a <- 2
                
                // then
                expect(b*) == 10
                expect(sideeffect) == 1
                
                // when
                a <- 6
                
                // then
                expect(b*) == 6
                expect(sideeffect) == 2
            }

        }

        context("kill") {

            it("kills observer") {
                // given
                let a = reactive(1)
                let b = definedAs { 2 * a* }
                var target = 0
                let o = onChangeDo(b) {  _ in
                    target = b*
                }

                // then
                expect(a.children) == toSet(b)
                expect(b.children) == toSet(o)
                expect(target == 2)

                // when
                a <- 2

                // then
                expect(target == 4)

                // when
                o.kill()

                // then
                expect(a.children) == toSet(b)
                expect(b.children) == Set()

                // when
                a <- 3

                // then
                expect(target) == 4
            }

            it("kills reactive") {
                // given
                let (a, b, c, d, e, f) = testGraph()

                // then
                expect(c*) == 2
                expect(e*) == 1
                expect(f*) == 10

                // when
                a <- 3

                // then
                expect(c*) == 6
                expect(e*) == 3
                expect(f*) == 12

                // when
                d.kill()
                a <- 1

                // then
                expect(f*) == 14
                expect(e.children) == toSet(f)

                // when
                f.kill()

                // then
                expect(e.children) == Set()

                // when
                a <- 3

                // then
                expect(c*) == 6
                expect(e*) == 3
                expect(f*) == 14
                expect(a.children) == toSet(c)
                expect(b.children) == toSet(c)

                // when
                c.kill()

                // then
                expect(a.children) == Set()
                expect(b.children) == Set()

                // when
                a <- 1

                // then
                expect(c*) == 6
                expect(e*) == 3
                expect(f*) == 14
            }


            it("kills all Hub") {
                // given
                let (a, _, c, d, e, f) = testGraph()

                // when
                // killAll-ing d makes f die too
                d.killAll()

                // then
                a <- 3
                expect(c*) == 6
                expect(e*) == 3
                expect(f*) == 10
            }
        }

    }

}
