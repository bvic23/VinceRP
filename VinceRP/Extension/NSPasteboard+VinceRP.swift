//
//  NSPasteboard+VinceRP.swift
//  vincerp
//
//  Created by Agnes Vasarhelyi on 04/11/15.
//  Copyright © 2015 Viktor Belenyesi. All rights reserved.
//

import AppKit

public extension NSPasteboard {

    func reactiveProperty<T:Equatable>(forProperty propertyName: String, initValue: T, initializer: ((Source<T>) -> ())? = nil) -> Hub<T> {
        return ReactivePropertyGenerator.property(self, propertyName: propertyName, initValue: initValue, initializer: initializer)
    }

    public var reactiveItems: Hub<[NSPasteboardItem]> {
        get {
            return reactiveProperty(forProperty: "pasteboardItems", initValue: self.pasteboardItems!)
        }
    }

}
