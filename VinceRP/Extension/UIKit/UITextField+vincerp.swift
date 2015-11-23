//
// Created by Viktor Belenyesi on 05/09/15.
// Copyright (c) 2015 Viktor Belenyesi. All rights reserved.
//

import UIKit

extension UITextField {

    public var reactiveText: Hub<String> {
        get {
            return reactiveProperty(forProperty: "text", initValue: self.text!) { emitter in
                self.addChangeHandler() { textField in
                    emitter <- textField.text!
                }
            }
        }
        
        set {
            newValue.onChange {
                self.text = $0
            }
        }
    }

}
