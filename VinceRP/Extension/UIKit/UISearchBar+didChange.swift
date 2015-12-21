//
// Created by Viktor Belenyesi on 26/09/15.
// Copyright (c) 2015 Viktor Belenyesi. All rights reserved.
//

import UIKit

private typealias EventHandler = (UISearchBar) -> ()
private var eventHandlers = [UISearchBar: [EventHandler]]()

extension UISearchBar {
    
    public func addChangeHandler(handler: (UISearchBar) -> ()) {
        if let handlers = eventHandlers[self] {
            eventHandlers[self] = handlers.arrayByAppending(handler)
        } else {
            eventHandlers[self] = [handler]
        }
        self.delegate = self
    }

    public func removeAllChangeHandler() {
        self.delegate = nil
        eventHandlers[self] = []
    }
    
}

extension UISearchBar : UISearchBarDelegate {
    
    public func searchBar(sender: UISearchBar, textDidChange searchText: String) {
        if let handlers = eventHandlers[sender] {
            for handler in handlers {
                handler(sender)
            }
        }
    }
    
}