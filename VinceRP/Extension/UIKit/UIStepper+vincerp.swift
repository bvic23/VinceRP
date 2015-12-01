//
// Created by Viktor Belenyesi on 14/09/15.
// Copyright (c) 2015 Viktor Belenyesi. All rights reserved.
//

import UIKit

public extension UIStepper {
    
    public var reactiveValue: Hub<Double> {
        get {
            return reactiveProperty(forProperty: "value", initValue: self.value)
        }
        
        set {
            newValue.onChange {
                self.value = $0
            }.dispatchOnMainQueue()
        }
    }
    
}
