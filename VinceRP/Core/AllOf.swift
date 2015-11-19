//
//  Created by Viktor Belényesi on 19/11/15.
//  Copyright © 2015 Viktor Belenyesi. All rights reserved.
//

public struct AllOf<T: Equatable> {
    
    private let hubs: [Hub<T>]
    
    public init(hubs: [Hub<T>]) {
        self.hubs = hubs
    }
    
    public func areAll(predicate: (T) -> Bool) -> Thenable<T> {
        return Thenable(hubs: self.hubs, predicate: predicate)
    }
    
}

public struct Thenable<T: Equatable> {
 
    private let hubs: [Hub<T>]
    private let predicate: (T) -> Bool
    
    public init(hubs: [Hub<T>], predicate: (T) -> Bool) {
        self.hubs = hubs
        self.predicate = predicate
    }
    
    public func then<U: Equatable>(thenValue: U) -> Elseable<T, U> {
        return Elseable(hubs: self.hubs, predicate: self.predicate, thenFunc: { _ in thenValue })
    }
 
    public func then<U: Equatable>(thenFunc: [Hub<T>] -> U) -> Elseable<T, U> {
        return Elseable(hubs: self.hubs, predicate: self.predicate, thenFunc: thenFunc)
    }
    
}

public class Elseable<T: Equatable, U: Equatable> {
    
    private let hubs: [Hub<T>]
    private let predicate: (T) -> Bool
    private let thenFunc: [Hub<T>] -> U
    
    public init(hubs: [Hub<T>], predicate: (T) -> Bool, thenFunc: [Hub<T>] -> U) {
        self.hubs = hubs
        self.predicate = predicate
        self.thenFunc = thenFunc
    }
    
    public func `else`(elseValue: U) -> Dynamic<U> {
        return `else`{ _ in elseValue }
    }
    
    public func `else`(elseFunc: [Hub<T>] -> U) -> Dynamic<U> {
        return definedAs {
            for h in self.hubs {
                if !self.predicate(h.value()) {
                    return elseFunc(self.hubs)
                }
            }
            return self.thenFunc(self.hubs)
        }
    }
    
}