//
// Created by Viktor Belényesi on 23/01/16.
// Copyright (c) 2016 Viktor Belenyesi. All rights reserved.
//

@testable import VinceRP

import Quick
import Nimble

class PropertyObserverSpec: QuickSpec {
    
    override func spec() {
        
        describe("basic") {
            var otherContext = 0
            let target = ObservableFooReactive()
            var result: Int? = nil
            var sut: PropertyObserver!
            
            beforeEach {
                sut = PropertyObserver(targetObject: target, propertyName: "name") {
                    result = $0.2 as? Int
                }
            }
            
            it("does not call the handler if the context is different") {
                // when
                sut.observeValueForKeyPath("name", ofObject: target, change: [:], context: &otherContext)
                
                // then
                expect(result).to(beNil())
            }
            
            it("does not call the handler if the keypath is different") {
                // when
                sut.observeValueForKeyPath("name2", ofObject: target, change: [:], context: &propertyObserverContext)
                
                // then
                expect(result).to(beNil())
            }
            
            it("does not call the handler if change dic is empty") {
                // when
                sut.observeValueForKeyPath("name", ofObject: target, change: [:], context: &propertyObserverContext)
                
                // then
                expect(result).to(beNil())
            }
            
            it("calls the handler") {
                // when
                sut.observeValueForKeyPath("name", ofObject: target, change: [NSKeyValueChangeNewKey: 2], context: &propertyObserverContext)
                
                // then
                expect(result) == 2
            }
            
            it("removes itself as the obsever on deinit") {
                // given
                weak var po: PropertyObserver?
                
                do {
                    // when
                    let strongPo = PropertyObserver(targetObject: target, propertyName: "name") {
                        result = $0.2 as? Int
                    }
                    po = strongPo

                    // then
                    expect(target.hasObserver) == true
                }                

                // then
                expect(target.hasObserver) == false
                expect(po).to(beNil())
            }
            
        }
        
    }
    
}
