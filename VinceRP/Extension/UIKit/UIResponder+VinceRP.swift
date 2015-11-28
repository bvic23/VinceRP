//
// Created by Agnes Vasarhelyi on 30/10/15.
// Copyright (c) 2015 Viktor Belenyesi. All rights reserved.
//

import UIKit

public extension UIResponder {

    public func reactiveProperty<T>(forProperty propertyName: String, initValue: T, initializer: ((Source<T>) -> ())? = nil) -> Hub<T> {
        return ReactivePropertyGenerator.property(self, propertyName: propertyName, initValue: initValue, initializer: initializer)
    }

    public func reactiveSource<T>(name propertyName: String, initValue: T) -> Source<T> {
        return ReactivePropertyGenerator.source(self, propertyName: propertyName, initValue: initValue)
    }

}
