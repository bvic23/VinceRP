//
// Created by Viktor Belenyesi on 1/24/16.
// Copyright (c) 2016 Viktor Belenyesi. All rights reserved.
//

@testable import VinceRP

import Quick
import Nimble

class StringVinceRPSpec: QuickSpec {
    
    override func spec() {
        
        describe("length") {
            
            it("works with empty string") {
                expect("".length) =~ 0
            }
            
            it("works with spaces only") {
                expect("    ".length) =~ 4
            }

            it("works with english alphabet") {
                expect("abcd".length) =~ 4
            }

            it("works with spaces inside") {
                expect("a  d".length) =~ 4
            }

            it("works with hungarian alphabet") {
                expect("ŐÚÁŰ".length) =~ 4
            }

            it("works with special characters") {
                expect("…^~≠".length) =~ 4
            }

            it("works with emojis") {
                expect("😀🙏ű^".length) =~ 4
            }

        }
        
    }
    
}
