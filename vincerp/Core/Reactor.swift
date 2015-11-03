//
// Created by Viktor Belenyesi on 18/04/15.
// Copyright (c) 2015 Viktor Belenyesi. All rights reserved.
//

public class Reactor: Node {
    
    private var alive = true
    
    override public func kill() {
        alive = false
        parents.forEach {
            $0.unlinkChild(self)
        }
    }

}
