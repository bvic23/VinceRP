//
// Created by Viktor Belenyesi on 14/09/15.
// Copyright (c) 2015 Viktor Belenyesi. All rights reserved.
//

extension NSObject {
    
    class func swizzleMethodSelector(origSelector: String!, withSelector: String!, forClass:AnyClass!) -> Bool {
        
        var originalMethod: Method?
        var swizzledMethod: Method?
        
        originalMethod = class_getInstanceMethod(forClass, Selector(origSelector))
        swizzledMethod = class_getInstanceMethod(forClass, Selector(withSelector))
        
        if (originalMethod != nil && swizzledMethod != nil) {
            if  class_addMethod(forClass, Selector(origSelector), method_getImplementation(swizzledMethod!), method_getTypeEncoding(swizzledMethod!)) {
                class_replaceMethod(forClass, Selector(withSelector), method_getImplementation(originalMethod!), method_getTypeEncoding(originalMethod!));
            } else {
                method_exchangeImplementations(originalMethod!, swizzledMethod!)
            }
            return true
        }
        return false
    }
    
    class func swizzleStaticMethodSelector(origSelector: String!, withSelector: String!, forClass:AnyClass!) -> Bool {
        
        var originalMethod: Method?
        var swizzledMethod: Method?
        
        originalMethod = class_getClassMethod(forClass, Selector(origSelector))
        swizzledMethod = class_getClassMethod(forClass, Selector(withSelector))
        
        if (originalMethod != nil && swizzledMethod != nil) {
            method_exchangeImplementations(originalMethod!, swizzledMethod!)
            return true
        }
        return false
    }
}
