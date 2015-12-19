//
//  Created by Viktor Belenyesi on 12/18/15.
//  Copyright © 2015 Viktor Belenyesi. All rights reserved.
//

import VinceRP

private var loggables = [Any]()
typealias Format = (Any) -> String

struct NamedHub<T> {
    private let name: String
    private let hub: Hub<T>
    
    init(name: String, hub: Hub<T>) {
        self.name = name
        self.hub = hub
        loggables.append(self)
    }
    
    func log(format: Format? = nil) -> Hub<T> {
        let f = defaultFormatIfNil(format)
        self.hub.onChange { i in
            let formattedMessage = f(i)
            print("\(self.name)> \(formattedMessage)")
        }
        return self.hub
    }
    
    private func defaultFormatIfNil(format: Format? = nil) -> Format {
        guard let f = format else {
            return { "\($0)" }
        }
        return f
    }

}

extension Hub where T: Any {

    func name(name: String) -> NamedHub<T> {
        return NamedHub(name: name, hub: self)
    }
    
}
