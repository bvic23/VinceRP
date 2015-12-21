//
// Created by Viktor Belenyesi on 18/04/15.
// Copyright (c) 2015 Viktor Belenyesi. All rights reserved.
//

@noreturn internal func abstractMethod(function: String = __FUNCTION__, file: String = __FILE__, line: Int = __LINE__) {
    fatalError("\(function) in \(file)[\(line)]: must be overriden in subclass implementations")
}

@noreturn internal func unreachableCode(function: String = __FUNCTION__, file: String = __FILE__, line: Int = __LINE__) {
    fatalError("\(function) in \(file)[\(line)]: must be unreachable, yous should not see this")
}
