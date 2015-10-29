//
// Created by Viktor Belenyesi on 26/09/15.
// Copyright (c) 2015 Viktor Belenyesi. All rights reserved.
//

private typealias EventHandler = (UISearchBar) -> ()
private var eventHandlers = [UISearchBar: [EventHandler]]()

extension UISearchBar {
    
    public func addChangeHandler(actionBlock: (UISearchBar) -> ()) {
        if let handlers = eventHandlers[self] {
            eventHandlers[self] = handlers.appendAfter(actionBlock)
        } else {
            eventHandlers[self] = [actionBlock]
        }
        self.delegate = self
    }

}

// TODO: add removeChangeHandler
extension UISearchBar : UISearchBarDelegate {
    public func searchBar(sender: UISearchBar, textDidChange searchText: String) {
        if let handlers = eventHandlers[sender] {
            for handler in handlers {
                handler(sender)
            }
        }
    }
}