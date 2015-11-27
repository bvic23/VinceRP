//
// Created by Viktor Belenyesi on 05/09/15.
// Copyright (c) 2015 Viktor Belenyesi. All rights reserved.
//

import UIKit

// TODO: Add tests for eventhandlers
// TODO: move separate file
public typealias ClickHandler = (UIButton) -> ()

public class ClickHandlerAction: Dispatchable {
    let handler: ClickHandler
    var dispatchQueue: dispatch_queue_t!
    
    init(handler: ClickHandler) {
        self.handler = handler
    }
    
    func execute(button:UIButton) {
        self.handler(button)
    }
    
    public func dispatchOnQueue(dispatchQueue: dispatch_queue_t?) -> ClickHandlerAction {
        self.dispatchQueue = dispatchQueue
        return self
    }
    
}

public func definedAs(handler: ClickHandler) -> ClickHandlerAction {
    return ClickHandlerAction(handler: handler)
}

private var eventHandlers: [UIButton: ClickHandlerAction]  = [UIButton: ClickHandlerAction]()
private let clickHandlerMethodName = "onClick:"

public extension UIButton {
    
    override public func mapReactiveEnabled(value: Bool) -> Bool {
        return value && !self.executing*
    }
    
    public var clickHandler: ClickHandlerAction? {
        get {
            return eventHandlers[self]
        }
        
        set {
            if let v = newValue {
                eventHandlers[self] = v
                self.executing <- false
                self.addTarget(self, action: Selector(clickHandlerMethodName), forControlEvents: .TouchUpInside)
            } else {
                eventHandlers.removeValueForKey(self)
                self.removeTarget(self, action: Selector(clickHandlerMethodName), forControlEvents: .TouchUpInside)
            }
        }
    }
    
    public func onClick(sender: UIButton) {
        
        dispatch_async(dispatch_get_main_queue(), {
            self.enabled = false
            self.executing <- true
        })
        
        let handler = eventHandlers[self]!
            
        if let q = handler.dispatchQueue {
            dispatch_async(q) {
                self.onClickThreadless(handler)
            }
        } else {
            self.onClickThreadless(handler)
        }
        
    }
    
    public func done() {
        dispatch_async(dispatch_get_main_queue(), {
            self.executing <- false
            self.enabled = true
        })
    }
    
    private func onClickThreadless(handler: ClickHandlerAction) {
        self.executing <- true
        handler.execute(self)
    }
    
    public var executing: Source<Bool> {
        get {
            return reactiveSource(name: "executing", initValue: false)
        }
        
        set {
        }
    }
    
}
