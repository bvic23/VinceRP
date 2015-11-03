//
//  EquatableArray.swift
//  vincerp
//
//  Created by Viktor Belényesi on 11/3/15.
//  Copyright © 2015 Viktor Belenyesi. All rights reserved.
//

extension Array: Equatable {}

func ==<C: CollectionType where C.Generator.Element: Equatable>
    (lhs: C?, rhs: C?) -> Bool {
        switch (lhs,rhs) {
        case (.Some(let lhs), .Some(let rhs)):
            return lhs == rhs
        case (.None, .None):
            return true
        default:
            return false
        }
}

public func ==<T:Equatable>(lhs: [T], rhs: [T]) -> Bool {
    if lhs.count != rhs.count {
        return false
    }

    for index in 0..<lhs.count {
        if lhs[index] != rhs[index] {
            return false
        }
    }

    return true
}

public func ==<T>(lhs: [T], rhs: [T]) -> Bool {
    return false
}

public func ==<T:Equatable>(lhs: [T?], rhs: [T?]) -> Bool {
    if lhs.count != rhs.count {
        return false
    }

    for index in 0..<lhs.count {
        if lhs[index] != rhs[index] {
            return false
        }
    }

    return true
}

