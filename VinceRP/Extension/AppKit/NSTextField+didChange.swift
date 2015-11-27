//
// Created by Agnes Vasarhelyi on 17/11/15.
// Copyright (c) 2015 Viktor Belenyesi. All rights reserved.
//

import AppKit

private typealias EventHandler = (NSTextField) -> ()
private var eventHandlers = [NSTextField: [EventHandler]]()

extension NSTextField {

    public func addChangeHandler(actionBlock: (NSTextField) -> ()) {
        if let handlers = eventHandlers[self] {
            eventHandlers[self] = handlers.arrayByAppending(actionBlock)
        } else {
            eventHandlers[self] = [actionBlock]
        }

        self.action = Selector("eventHandler:")
        self.target = self
    }

    // TODO: add removeChangeHandler
    public func eventHandler(sender: NSTextField) {
        if let handlers = eventHandlers[sender] {
            for handler in handlers {
                handler(sender)
            }
        }
    }

}
