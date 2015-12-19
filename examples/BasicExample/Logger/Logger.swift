//
//  Created by Viktor Belenyesi on 12/18/15.
//  Copyright © 2015 Viktor Belenyesi. All rights reserved.
//

import VinceRP

private var loggables = [Any]()
typealias Format = (Any) -> String

class NamedHub<T> {
    private let name: String
    private var format: Format
    private var hub: Hub<T>
    
    init(name: String, hub: Hub<T>) {
        self.name = name
        self.hub = hub
        self.format = { "\($0)" }
        
        hub.onChange { message in
            let formattedMessage = self.format(message)
            print("\(self.name)> \(formattedMessage)")
        }
        
        loggables.append(self)
    }
    
    func log(format: Format? = nil) -> Hub<T> {
        if let f = format {
            self.format = f
        }
        return self.hub
    }

}

extension Hub {

    func name(name: String) -> NamedHub<T> {
        return NamedHub(name: name, hub: self)
    }
    
}
