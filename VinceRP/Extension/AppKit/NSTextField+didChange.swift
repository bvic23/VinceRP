//
// Created by Agnes Vasarhelyi on 17/11/15.
// Copyright (c) 2015 Viktor Belenyesi. All rights reserved.
//

import AppKit

private typealias EventHandler = (NSTextField) -> ()
private var eventHandlers = [NSTextField: [EventHandler]]()

extension NSTextField: NSTextFieldDelegate {

    public func addChangeHandler(handler: (NSTextField) -> ()) {
        if let handlers = eventHandlers[self] {
            eventHandlers[self] = handlers.arrayByAppending(handler)
        } else {
            eventHandlers[self] = [handler]
        }

        self.delegate = self
    }

    override public func controlTextDidChange(obj: NSNotification) {
        if let handlers = eventHandlers[self] {
            for handler in handlers {
                handler(self)
            }
        }
    }
    
    public func removeAllChangeHandler() {
        self.target = nil
        eventHandlers[self] = []
    }
    
}
