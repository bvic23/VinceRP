//
// Created by Viktor Belenyesi on 27/09/15.
// Copyright (c) 2015 Viktor Belenyesi. All rights reserved.
//

import UIKit

public extension UIView {
    
    public var reactiveHidden: Hub<Bool> {
        
        get {
            return reactiveProperty(forProperty: "hidden", initValue: self.hidden)
        }
        
        set {
            newValue.onChange {
                self.hidden = $0
                self.reactiveHiddenDidChange()
            }.dispatchOnMainQueue()
        }
        
    }
    
    public func reactiveHiddenDidChange() {}
    
}
