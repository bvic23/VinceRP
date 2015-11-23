//
// Created by Viktor Belenyesi on 18/04/15.
// Copyright (c) 2015 Viktor Belenyesi. All rights reserved.
//

extension Array {

    public func arrayByPrepending(elem: Element) -> Array<Element> {
        var mutableCopy = self
        mutableCopy.insert(elem, atIndex: 0)
        let result = mutableCopy
        return result
    }

    public func arrayByAppending(elem: Element) -> Array<Element> {
        var mutableCopy = self
        mutableCopy.append(elem)
        let result = mutableCopy
        return result
    }

}

extension Array where Element: SequenceType {
    
    public func flatten() -> [Element.Generator.Element] {
        return self.flatMap{$0}
    }
    
}

