//
// Created by Viktor Belenyesi on 18/04/15.
// Copyright (c) 2015 Viktor Belenyesi. All rights reserved.
//

import vincerp

import Quick
import Nimble

infix operator * { associativity left precedence 160 }

func *(left: String, right: Int) -> String {
    var result = ""
    for _ in 0 ..< right {
        result += left
    }
    return result
}

class BasicSpec: QuickSpec {

    override func spec() {

        describe("basic") {

            context("reactive variable") {

                it("works") {
                    // given
                    let a = reactive(1)
                    let b = reactive(2)

                    // when
                    let c = definedAs {
                        a* + b*
                    }

                    // then
                    expect(c*) == 3

                    // when
                    a <- 4
                    expect(c*) == 6
                }

//                it("works with options") {
//                    // given
//                    let a: Var<Optional<Int>> = Var<Optional<Int>>(nil)
//                    let b: Var<Int?> = reactive(nil)
//                    let c: Dynamic<Int?> = definedAs {
//                        a*.flatMap {
//                            x in
//                            b*.map {
//                                y in
//                                x + y
//                            }
//                        }
//                    }
//
//                    // when
//                    a <- 1
//                    b <- 2
//
//                    // then
//                    expect(c*) == 3
//                }

                it("works with a real graph") {
                    // given
                    let (n1, n2, n3, n4, n5, n6) = testGraph()

                    // then
                    expect(n6*) == 10

                    // when
                    n1 <- 3

                    // parents
                    expect(n6*) == 12
                    expect(n1.parents.count) == 0
                    expect(n2.parents.count) == 0
                    expect(n3.parents) == toSet(n1, n2)
                    expect(n6.parents) == toSet(n4, n5)

                    // children
                    expect(n1.children) == toSet(n3)
                    expect(n6.children.count) == 0

                    // descendants
                    expect(n4.descendants) == toSet(n6)
                    expect(n4.descendants.count) == 1
                    expect(n3.descendants) == toSet(n4, n5, n6)
                    expect(n3.descendants.count) == 3

                    // descendants
                    expect(n4.ancestors) == toSet(n1, n2, n3)
                    expect(n4.ancestors.count) == 3
                    expect(n3.ancestors) == toSet(n1, n2)
                    expect(n3.ancestors.count) == 2
                }

                it("works with complex values") {
                    // when
                    let a:Source<[Int]> = reactive([1, 2, 3])
                    let b = reactive(3)
                    let c = definedAs {
                        a*.prepend(b*)
                    }
                    let d = definedAs {
                        c*.map {
                            "omg" * $0
                        }
                    }
                    let e = reactive("wtf")
                    let f = definedAs {
                        d*.appendAfter(e*).joinWithSeparator("")
                    }

                    // then
                    expect(f*) == "omgomgomgomgomgomgomgomgomgwtf"

                    // when
                    a <- [Int]()

                    // then
                    expect(f*) == "omgomgomgwtf"

                    // when
                    e <- "wtfbbq"

                    // then
                    expect(f*) == "omgomgomgwtfbbq"
                    expect(e.descendants) == toSet(f)
                    expect(c.ancestors) == toSet(a, b)
                }

            }

            context("language features") {

                it("works with pattern matching") {
                    // given
                    let a = reactive(1)
                    let b = reactive(2)

                    // when
                    let c = definedAs { () -> Int in
                        switch a* {
                            case 0: return b*
                            default: return a*
                        }
                    }

                    // then
                    expect(c*) == 1

                    // when
                    a <- 0

                    // then
                    expect(c*) == 2
                }

                it("useInByNameParameters") {
                    // given
                    let a = reactive(1)

                    // when
                    let b = definedAs {
                        Optional.Some(1) ?? a*
                    }

                    // then
                    expect(b*) == 1
                }

            }

            context("observing") {

                it("works") {
                    // given
                    let a = reactive(1)
                    var count = 0

                    // when
                    _ = onChangeDo(a) {  _ in
                        count = a* + 1
                    }

                    // then
                    expect(count) == 2

                    // when
                    a <- 4

                    // then
                    expect(count) == 5
                }

                it("works without storing the observer") {
                    // given
                    let a = reactive(1)
                    var count = 0

                    // when
                    onChangeDo(a) {  _ in
                        count = a* + 1
                    }

                    // then
                    expect(count) == 2

                    // when
                    a <- 4

                    // then
                    expect(count) == 5
                }

                it("can skip initial value") {
                    // given
                    let a = reactive(1)
                    var count = 0

                    // when
                    _ = onChangeDo(a, skipInitial: true) {  _ in
                        count = count + 1
                    }

                    // then
                    expect(count) == 0

                    // when
                    a <- 2

                    // thne
                    expect(count) == 1
                }

                it("works with a complex graph") {
                    // given
                    let a = reactive(1)
                    let b = definedAs {
                        a* * 2
                    }
                    let c = definedAs {
                        a* + 1
                    }
                    let d = definedAs {
                        b* + c*
                    }

                    // when
                    var bS = 0
                    _ = onChangeDo(b) {  _ in
                        bS += 1
                    }

                    var cS = 0
                    _ = onChangeDo(c) {  _ in
                        cS += 1
                    }

                    var dS = 0
                    _ = onChangeDo(d) {  _ in
                        dS += 1
                    }

                    // then
                    expect(bS) == 1
                    expect(cS) == 1
                    expect(dS) == 1

                    // when
                    a <- 2

                    // then
                    expect(bS) == 2
                    expect(cS) == 2
                    expect(dS) == 2

                    // when
                    a <- 1

                    // then
                    expect(bS) == 3
                    expect(cS) == 3
                    expect(dS) == 3
                }
            }

            context("error handling") {

                it("catches simple errors") {
                    // given
                    let a = reactive(1)
                    var errors = 0
                    var sideeffects = 0
                    _ = onErrorDo(a) { _ in
                        errors++
                    }
                    _ = onChangeDo(a, skipInitial:true) {  _ in
                        sideeffects++
                    }

                    // when
                    a <- NSError(domain: "vincerp", code: 1, userInfo: nil)

                    // then
                    expect(errors) == 1
                    expect(sideeffects) == 0
                    expect(a.error().domain) == "vincerp"
                }

                it("works without storing the error handler") {
                    // given
                    let e = NSError(domain: "domain.com", code: 1, userInfo: nil)
                    let a = reactive(1)
                    var error: NSError? = nil
                    onErrorDo(a) { _ in
                        error = a.error()
                    }

                    // when
                    a <- e

                    // then
                    expect(error).to(equal(e))
                }


                it("allows access the error") {
                    // given
                    let e = NSError(domain: "domain.com", code: 1, userInfo: nil)
                    let a = reactive(1)
                    var error: NSError? = nil
                    onErrorDo(a) {  _ in 
                        error = a.error()
                    }

                    // when
                    a <- e

                    // then
                    expect(error).to(equal(e))
                }

                it("works with multiple error handlers") {
                    // given
                    let a = reactive(1)
                    var e1 = 0
                    var e2 = 0
                    onErrorDo(a) {  _ in
                        e1++
                    }
                    onErrorDo(a) {  _ in
                        e2++
                    }

                    // when
                    a <- NSError(domain: "domain.com", code: 1, userInfo: nil)

                    // then
                    expect(e1) == 1
                    expect(e2) == 1
                }

            }
        }

    }

}
