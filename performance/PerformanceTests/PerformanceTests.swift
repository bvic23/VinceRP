//
//  PerformanceTests.swift
//  PerformanceTests
//
//  Created by Viktor Belényesi on 30/11/15.
//  Copyright © 2015 Viktor Belenyesi. All rights reserved.
//

import XCTest
@testable import VinceRP

class Performance: XCTestCase {
    
    func testPerformanceExample() {
        
        self.measureBlock {
            // given
            var counter = 0
            
            let observable = reactive(0)
            
            let _ = observable.onChange { counter += $0 }
            
            for i in 1..<10000 {
                observable <- i
            }
            
        }
    }
    
}
