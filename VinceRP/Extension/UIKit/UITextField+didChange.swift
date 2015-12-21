//
// Created by Viktor Belenyesi on 26/09/15.
// Copyright (c) 2015 Viktor Belenyesi. All rights reserved.
//

import UIKit

private typealias EventHandler = (UITextField) -> ()
private var eventHandlers = [UITextField: [EventHandler]]()

extension UITextField {
    
    public func addChangeHandler(handler: (UITextField) -> ()) {
        if let handlers = eventHandlers[self] {
            eventHandlers[self] = handlers.arrayByAppending(handler)
        } else {
            eventHandlers[self] = [handler]
        }
        
        self.addTarget(self, action: Selector("eventHandler:"), forControlEvents: .EditingChanged)
    }
    
    public func removeAllChangeHandler() {
        eventHandlers[self] = []
    }
    
    public func eventHandler(sender: UITextField) {
        if let handlers = eventHandlers[sender] {
            for handler in handlers {
                handler(sender)
            }
        }
    }
    
}
