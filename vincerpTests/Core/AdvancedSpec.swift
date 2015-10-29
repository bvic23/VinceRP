//
// Created by Viktor Belenyesi on 18/04/15.
// Copyright (c) 2015 Viktor Belenyesi. All rights reserved.
//

@testable import vincerp

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
                // TODO: enable this test
                /*
                it("works with nested reactives") {
                    // given
                    let a = reactive(1)
                    let b: Dynamic<(Dynamic<Int>, Dynamic<Int>)> = definedAs { () -> (Dynamic<Int>, Dynamic<Int>) in
                        (definedAs{ a* },  definedAs{ myRandom() })
                    }
                    let r = b*.1*

                    // when
                    a <- 2

                    // then
                    expect(b*.1*) == r
                }
                */
                
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
                    expect(i) == 2
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

            it("works with foreach") {
                // given
                let a = reactive(1)
                var count = 0

                // when
                a.foreach {
                    count = $0 + 1
                }

                // then
                expect(count) == 2

                // when
                a <- 4

                // then
                expect(count) == 5
            }

            it("can skip errors") {
                // given
                let x = reactive(1)
                let y = definedAs { x* + 1 }.skipErrors()
                var count = 0
                onErrorDo(y) {  _ in
                    count++
                }

                // when
                x <- fakeError

                // then
                expect(count) == 0
            }

            it("can map values") {
                // given
                let a = reactive(10)
                let b = definedAs { a* + 2 }
                let c = a.map { $0 * 2 }
                let d = b.map { $0 + 3 }

                // then
                expect(c*) == 20
                expect(d*) == 15

                // when
                a <- 1

                // then
                expect(c*) == 2
                expect(d*) == 6
            }

            it("can map all values") {
                // given
                let a = reactive(10)
                let b = definedAs { 100 / a* }
                let c = b.mapAll { (p:Try<Int>) -> Try<Int> in
                    switch p {
                        case .Success(let box): return Try(box.value * 2)
                        default: return Try(1337)
                    }
                }
                let d = b.mapAll { (p:Try<Int>) -> Try<String> in
                    switch p {
                        case .Success( _): return Try(fakeError)
                        case .Failure(let w): return Try(w.description)
                    }
                }

                // then
                expect(c*) == 20
                expect(d.toTry().isFailure()) == true

                // when
                a <- fakeError

                // then
                expect(c*) == 1337
                expect(d.toTry().isSuccess()) == true
            }

            it("filters") {
                // given
                let a = reactive(10)
                let b = a.filter { $0 > 5 }

                // when
                a <- 1

                // then
                expect(b*) == 10

                // when
                a <- 6

                // then
                expect(b*) == 6

                // when
                a <- 2

                // then
                expect(b*) == 6

                // when
                a <- 19

                // then
                expect(b*) == 19
            }
            
            it("blocks observers") {
                // given
                let a = reactive(10)
                let b = a.filter { $0 > 5 }
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
            
            it("filters all") {
                // given
                let a = reactive(10)
                let b = definedAs { 100 / a* }
                let c = b.filterAll { $0.isSuccess() }

                // then
                expect(c*) == 10

                // when
                a <- 9

                // then
                expect(c*) == 11

                // when
                a <- fakeError

                // then
                expect(c*) == 11

                // when
                a <- 1

                // then
                expect(c*) == 100
            }

            it("reduces") {
                // given
                let a = reactive(1)
                let b = a.reduce { $0 * $1 }

                // when
                a <- 2
                expect(b*) == 2

                // when
                a <- 3
                expect(b*) == 6

                // when
                a <- 4
                expect(b*) == 24
            }

            it("reduces all") {
                // given
                let a = reactive(1)
                let b = definedAs { 100 / a* }
                let c = b.reduceAll { (x, y) in
                    switch (x, y) {
                        case (.Success(let a), .Success(let b)): return Try(a.value + b.value)
                        case (.Failure(_), .Failure(_)): return Try(1337)
                        case (.Failure(let a), .Success(_)): return .Failure(a)
                        case (.Success(_), .Failure(let b)): return .Failure(b)
                    }
                }

                // then
                expect(c*) == 100

                // when
                a <- fakeError

                // then
                expect(c.toTry().isFailure()) == true

                // when
                a <- 10

                // then
                expect(c.toTry().isFailure()) == true

                // when
                a <- 100

                // then
                expect(c.toTry().isFailure()) == true

                // when
                a <- fakeError

                // then
                expect(c*) == 1337

                // when
                a <- 10

                // then
                expect(c*) == 1347
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


            it("kills all Rx") {
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
