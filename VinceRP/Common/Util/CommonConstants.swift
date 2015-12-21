//
// Created by Viktor Belenyesi on 18/04/15.
// Copyright (c) 2015 Viktor Belenyesi. All rights reserved.
//

@noreturn internal func abstractMethod(fn: String = __FUNCTION__) {
    fatalError("\(fn) must be overriden in subclass implementations")
}

@noreturn internal func unreachableCode(fn: String = __FUNCTION__) {
    fatalError("This part of \(fn) must be unreachable, yous should not see this")
}
