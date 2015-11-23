//
//  NSView+VinceRP.swift
//  vincerp
//
//  Created by Agnes Vasarhelyi on 17/11/15.
//  Copyright © 2015 Viktor Belenyesi. All rights reserved.
//

import Cocoa

public extension NSView {
    
    public var reactiveHidden: Hub<Bool> {
        get {
            return reactiveProperty(forProperty: "hidden", initValue: true)
        }
        
        set {
            newValue.onChange {
                self.hidden = self.mapReactiveHidden($0)
                self.reactiveHiddenDidChange()
            }
        }
    }
    
    public func mapReactiveHidden(value: Bool) -> Bool {
        return value
    }
    
    public func reactiveHiddenDidChange() {}
    
}
