//
// Created by Viktor Belenyesi on 21/04/15.
// Copyright (c) 2015 Viktor Belenyesi. All rights reserved.
//

import Quick
import Nimble

class FunctionalDictionarySpec: QuickSpec {

    override func spec() {

        describe("mapValues") {

            it("maps empty dic to empty dic") {
                // given
                let s = [Int: Int]()

                // when
                let r = s.mapValues { $0 * 2 }

                // then
                expect(r.count) == 0
            }

            it("maps values correctly") {
                // given
                let s = [1: 1, 2: 2, 3: 3]
                
                // when
                let r = s.mapValues { $0 * 2 }
                
                // then
                expect(r) == [1: 2, 2: 4, 3: 6]
            }
            
        }

    }

}
