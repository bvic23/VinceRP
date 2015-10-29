//
// Created by Viktor Belenyesi on 18/04/15.
// Copyright (c) 2015 Viktor Belenyesi. All rights reserved.
//

extension Array {

    public func prepend(elem: Element) -> Array<Element> {
        var mutableCopy = self
        mutableCopy.insert(elem, atIndex: 0)
        let result = mutableCopy
        return result
    }

    public func appendAfter(elem: Element) -> Array<Element> {
        var mutableCopy = self
        mutableCopy.append(elem)
        let result = mutableCopy
        return result
    }

}

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


