//
// Created by Viktor Belenyesi on 26/09/15.
// Copyright (c) 2015 Viktor Belenyesi. All rights reserved.
//

import UIKit

private typealias EventHandler = (UITextField) -> ()
private var eventHandlers = [UITextField: [EventHandler]]()

extension UITextField {
    
    public func addChangeHandler(actionBlock: (UITextField) -> ()) {
        if let handlers = eventHandlers[self] {
            eventHandlers[self] = handlers.appendAfter(actionBlock)
        } else {
            eventHandlers[self] = [actionBlock]
        }
        
        self.addTarget(self, action: Selector("eventHandler:"), forControlEvents: .EditingChanged)
    }
    
    // TODO: add removeChangeHandler
    public func eventHandler(sender: UITextField) {
        if let handlers = eventHandlers[sender] {
            for handler in handlers {
                handler(sender)
            }
        }
    }
    
}
