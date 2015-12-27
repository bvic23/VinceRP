//
// Created by Viktor Belenyesi on 12/21/15.
// Copyright (c) 2015 Viktor Belenyesi. All rights reserved.
//

import UIKit

public typealias ClickHandler = (UIButton) -> ()

public class ClickHandlerAction: Dispatchable {
    public var dispatchQueue: dispatch_queue_t?
    let handler: ClickHandler
    
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
