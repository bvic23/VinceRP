//
// Created by Agnes Vasarhelyi on 17/11/15.
// Copyright (c) 2015 Viktor Belenyesi. All rights reserved.
//

import AppKit

extension NSTextField {

    public var reactiveText: Hub<String> {
        get {
            return reactiveProperty(forProperty: "text", initValue: self.stringValue) { emitter in
                self.addChangeHandler() { textField in
                    emitter <- textField.stringValue
                }
            }
        }

        set {
            newValue.onChange {
                self.stringValue = $0
            }.dispatchOnMainQueue()
        }
    }

}
