//
// Created by Viktor Belenyesi on 20/04/15.
// Copyright (c) 2015 Viktor Belenyesi. All rights reserved.
//

@testable import VinceRP

import Quick
import Nimble

class WeakSetSpec: QuickSpec {
    
    override func spec() {
        
        context("insert") {
            
            it("inserts new weakreference to empty set") {
                // given
                let foo = Foo()
                let ws = WeakSet<Foo>()
                
                // when
                ws.insert(foo)
                
                // then
                expect(ws.set) == toSet(foo)
            }
            
            it("won't insert a new object with a different set") {
                // given
                let foo1 = Foo()
                let foo2 = Foo()
                let ws = WeakSet([foo1])
                
                // when
                ws.insert(foo2)
                
                // then
                expect(ws.set) == toSet(foo1)
            }
            
            it("inserts a new value with a different hash") {
                // given
                let foo1 = Foo()
                let foo2 = Foo(hashValue: 2)
                let ws = WeakSet([foo1])
                
                // when
                ws.insert(foo2)
                
                // then
                expect(ws.set) == Set([foo1, foo2])
            }
        }
        
    }
    
}
