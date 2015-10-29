//
// Created by Viktor Belenyesi on 27/09/15.
// Copyright (c) 2015 Viktor Belenyesi. All rights reserved.
//

import UIKit

public extension UIActivityIndicatorView {
    
    override public func reactiveHiddenDidChange() {
        if self.hidden {
            self.stopAnimating()
        } else {
            self.startAnimating()
        }
    }

}
