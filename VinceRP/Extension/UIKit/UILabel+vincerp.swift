//
// Created by Viktor Belenyesi on 14/09/15.
// Copyright (c) 2015 Viktor Belenyesi. All rights reserved.
//

import UIKit

public extension UILabel {
    
    public var reactiveText: Hub<String> {
        get {
            return reactiveProperty(forProperty: "text", initValue: self.text!)
        }
        
        set {
            newValue.onChange {
                self.text = $0
            }.dispatchOnMainQueue()
        }
    }
    
}
