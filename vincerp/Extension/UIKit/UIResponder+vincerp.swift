//
//  UIResponder+VinceRP.swift
//  VinceRP
//
//  Created by Agnes Vasarhelyi on 30/10/15.
//  Copyright © 2015 Viktor Belenyesi. All rights reserved.
//

import UIKit

public extension UIResponder {
    
    public func reactiveProperty<T:Equatable>(forProperty propertyName: String, initValue: T, initializer: ((Source<T>) -> ())? = nil) -> Hub<T> {
        return ReactivePropertyGeneator.property(self, propertyName: propertyName, initValue: initValue, initializer: initializer)
    }
    
    public func reactiveEmitter<T:Equatable>(name propertyName: String, initValue: T) -> Source<T> {
        return ReactivePropertyGeneator.emitter(self, propertyName: propertyName, initValue: initValue)
    }
    
}
