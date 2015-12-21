//
// Created by Viktor Belenyesi on 09/05/15.
// Copyright (c) 2015 Viktor Belenyesi. All rights reserved.
//

@testable import VinceRP

import Quick
import Nimble

infix operator =~ { associativity left precedence 130 }

func =~<T: Equatable> (left: Expectation<T>, right: T?) -> Void {
    return left.toEventually(equal(right))
}

func =~<T: Equatable> (left: Expectation<[T]>, right: [T]?) -> Void {
    return left.toEventually(equal(right))
}

public func testGraph() -> (Source<Int>, Source<Int>, Dynamic<Int>, Dynamic<Int>, Dynamic<Int>, Dynamic<Int>) {
    let n1 = reactive(1)
    let n2 = reactive(2)

    let n3 = definedAs { n1* * n2* }
    let n4 = definedAs { n3* + 5 }
    let n5 = definedAs { n3* / 2 }
    let n6 = definedAs { n4* - n5* + 4 }

    return (n1, n2, n3, n4, n5, n6)
}
