//
// Created by Viktor Belenyesi on 27/09/15.
// Copyright (c) 2015 Viktor Belenyesi. All rights reserved.
//

import UIKit

public extension UIControl {
    
    public var reactiveEnabled: Hub<Bool> {
        get {
            return reactiveSource(name: "enabled", initValue: self.enabled)
        }
        
        set {
            newValue.onChange {
                self.enabled = self.mapReactiveEnabled($0)
                self.reactiveEnabledDidChange()
            }
        }
    }
    
    public func mapReactiveEnabled(value: Bool) -> Bool {
        return value
    }
    
    public func reactiveEnabledDidChange() {
    }
}

