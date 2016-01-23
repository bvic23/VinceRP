//
//  Created by Viktor Belenyesi on 11/28/15.
//  Copyright © 2015 Viktor Belenyesi. All rights reserved.
//

@testable import VinceRP
import XCTest

class Performance: XCTestCase {

    func testPerformanceExample() {
        
        self.measureBlock {
            // given
            var counter = 0
            
            let observable = reactive(0)
            
            let _ = observable.onChange { counter += $0 }
            
            for i in 1..<1000 {
                observable <- i
            }
            
        }
    }

}
