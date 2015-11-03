//
//  Flattenable.swift
//  vincerp
//
//  Created by Viktor Belényesi on 11/3/15.
//  Copyright © 2015 Viktor Belenyesi. All rights reserved.
//

public protocol Flattenable {
    func flatten() -> Self
}

extension Flattenable where Self: SequenceType {
    
    public func flatten() -> Self {
        return self
    }
    
}
