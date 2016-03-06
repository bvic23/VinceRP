//
//  Created by Viktor Belényesi on 03/03/16.
//  Copyright © 2016 Viktor Belenyesi. All rights reserved.
//

import VinceRP
import Cocoa

extension NSToolbar {
    
    public func reactiveProperty<T>(forProperty propertyName: String, initValue: T?, initializer: ((Source<T>) -> ())? = nil) -> Hub<T> {
        return ReactivePropertyGenerator.instance.property(self, propertyName: propertyName, initValue: initValue, initializer: initializer)
    }
    
    public func reactiveEmitter<T>(name propertyName: String, initValue: T?) -> Source<T> {
        return ReactivePropertyGenerator.instance.source(self, propertyName: propertyName, initValue: initValue)
    }
    
    public var reactiveSelectedItem: Hub<String> {
        get {
            return reactiveProperty(forProperty: "selectedItemIdentifier", initValue: self.selectedItemIdentifier)
        }
        
        set {
            newValue.onChange {
                self.selectedItemIdentifier = $0
            }.dispatchOnMainQueue()
        }
    }
    
}
