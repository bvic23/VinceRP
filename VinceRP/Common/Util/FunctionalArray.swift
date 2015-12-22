//
// Created by Viktor Belenyesi on 18/04/15.
// Copyright (c) 2015 Viktor Belenyesi. All rights reserved.
//

extension Array {

    public func arrayByPrepending(elem: Element) -> [Element] {
        var mutableCopy = self
        mutableCopy.insert(elem, atIndex: 0)
        let result = mutableCopy
        return result
    }

    public func arrayByAppending(elem: Element) -> [Element] {
        var mutableCopy = self
        mutableCopy.append(elem)
        let result = mutableCopy
        return result
    }
    
    public func arrayByRemoving(@noescape predicate: (Element) throws -> Bool)  -> [Element] {
        var mutableCopy = self
        mutableCopy.remove(predicate)
        let result = mutableCopy
        return result
    }

    public mutating func remove(@noescape predicate: (Element) throws -> Bool) {
        do {
            if let index = try indexOf(predicate) {
                self.removeAtIndex(index)
            }
        } catch {
            return
        }
    }

}

extension Array where Element: SequenceType {
    
    public func flatten() -> [Element.Generator.Element] {
        return self.flatMap{$0}
    }
    
}

