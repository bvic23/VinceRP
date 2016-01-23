//
// Created by Viktor Belenyesi on 1/23/16.
// Copyright (c) 2016 Viktor Belenyesi. All rights reserved.
//

var propertyObserverContext = 0

class PropertyObserver: NSObject {
    let targetObject: NSObject
    let propertyName: String
    let propertyChangeHandler: (NSObject, String, AnyObject) -> Void
    
    init(targetObject:NSObject, propertyName: String, propertyChangeHandler: (NSObject, String, AnyObject) -> Void) {
        self.targetObject = targetObject
        self.propertyName = propertyName
        self.propertyChangeHandler = propertyChangeHandler
        super.init()
        self.targetObject.addObserver(self, forKeyPath: propertyName, options: .New, context: &propertyObserverContext)
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if context == &propertyObserverContext {
            if self.propertyName == keyPath {
                if let newValue = change?[NSKeyValueChangeNewKey] {
                    self.propertyChangeHandler(self.targetObject, self.propertyName, newValue)
                }
            }
        }
    }
    
    deinit {
        self.targetObject.removeObserver(self, forKeyPath: propertyName, context: &propertyObserverContext)
    }
    
}
