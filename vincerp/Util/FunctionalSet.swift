//
// Created by Viktor Belenyesi on 21/04/15.
// Copyright (c) 2015 Viktor Belenyesi. All rights reserved.
//

public func toSet<T:Hashable>(e: T...) -> Set<T> {
    return Set(e)
}


extension Set {
    
    public func partition(@noescape filterFunc: (Generator.Element) -> Bool) -> (Set<Generator.Element>, Set<Generator.Element>) {
        let result1 = self.filter(filterFunc)
        let result2 = self.filter{!filterFunc($0)}
        return (Set(result1), Set(result2))
    }

    public func groupBy<U>(@noescape filterFunc: (Generator.Element) -> U) -> [U : Set<Generator.Element>] {
        var result = [U: Set<Generator.Element>]()
        for i in self {
            let u = filterFunc(i)
            guard let bag = result[u] else {
                result[u] = toSet(i)
                continue
            }
            result[u] = bag ++ toSet(i)
        }
        return result
    }
    
}

extension SequenceType where Generator.Element: Hashable {
    
    public func hasElementPassingTest(@noescape filterFunc: (Self.Generator.Element) -> Bool) -> Bool {
        let result = self.filter(filterFunc)
        return result.count > 0
    }
    
}

extension SequenceType where Generator.Element: Comparable {
    
    public func min(fallbackValue: Self.Generator.Element) -> Self.Generator.Element {
        guard let result = self.minElement() else {
            return fallbackValue
        }
        return result
    }
    
    public func max(fallbackValue: Self.Generator.Element) -> Self.Generator.Element {
        guard let result = self.maxElement() else {
            return fallbackValue
        }
        return result
    }
}

public protocol Flattenable {
    func flatten() -> Self
}

extension Flattenable where Self: SequenceType {
    
    public func flatten() -> Self {
        return self
    }
    
}

extension Set: Flattenable {
    
    public func filter(@noescape includeElement: (Element) -> Bool) -> Set<Element> {
        let arr = Array(self)
        let result = arr.filter(includeElement)
        return Set(result)
    }
    
    public func map<U>(@noescape transform: (Element) -> U) -> Set<U> {
        let arr = Array(self)
        let result = arr.map(transform)
        return Set<U>(result)
    }
    
    public func flatMap<U:SequenceType>(transform: (Element) -> U) -> Set<U.Generator.Element> {
        let arr = Array(self)
        let result = arr.flatMap(transform)
        return Set<U.Generator.Element>(result)
    }
    
    public func flatMap<T>(@noescape transform: (Element) -> T?) -> Set<T> {
        let arr = Array(self)
        let result = arr.flatMap(transform)
        return Set<T>(result)
    }
    
}

extension Set where Element:SequenceType, Element.Generator.Element:Hashable {
    
    public func flatten() -> Set<Element.Generator.Element> {
        return self.flatMap{$0}
    }
    
}

infix operator ++ { associativity left precedence 160 }
public func ++<T:Hashable>(left: Set<T>, right: Set<T>) -> Set<T> {
    return left.union(right)
}

public func ++<T:Hashable>(left: Set<T>, right: T) -> Set<T> {
    return left ++ toSet(right)
}
