//
// Created by Viktor Belényesi on 04/01/16.
// Copyright (c) 2016 Viktor Belenyesi. All rights reserved.
//

@testable import VinceRP

import Quick
import Nimble

/*
    static func createObserver<T>(targetObject: AnyObject, propertyName: String, initValue: T?) -> PropertyObserver {
    public static func source<T>(targetObject: AnyObject, propertyName: String, initValue: T?, initializer: ((Source<T>) -> ())? = nil) -> Source<T> {
    public static func property<T>(targetObject: AnyObject, propertyName: String, initValue: T?, initializer: ((Source<T>) -> ())? = nil) -> Hub<T> {
*/

class ReactivePropertyGeneratorSpec: QuickSpec {
    
    override func spec() {
        
        describe("basic") {
            
            var sut: ReactivePropertyGenerator!
            
            beforeEach {
                sut = ReactivePropertyGenerator()
            }
            
            it("generates a proper key") {
                // when
                let key = sut.getKey(FooReactive(), propertyName: "bar")
                
                // then
                expect(key) == "1bar"
            }
            
            it("does not contain any emitter initially") {
                // when
                let e: Source<Int>? = sut.getEmitter(FooReactive(), propertyName: "name")

                // then
                expect(e).to(beNil())
            }
            
            it("returns with the same emitter to the same hash") {
                // given
                let e1: Source<Int> = sut.createEmitter(FooReactive(), propertyName: "name", initValue: nil)

                // when
                let e2: Source<Int> = sut.getEmitter(FooReactive(), propertyName: "name")!
                
                // then
                expect(e1) == e2
            }
            
            it("returns with the same emitter to a different hash") {
                // given
                let e1: Source<Int> = sut.createEmitter(FooReactive(), propertyName: "name", initValue: nil)
                
                // when
                let e2: Source<Int>? = sut.getEmitter(FooReactive(hashValue: 2), propertyName: "name")
                
                // then
                expect(e1).notTo(equal(e2))
            }
            
            it("synthesizes source with no value for no init value") {
                // when
                let e1: Source<Int> = sut.synthesizeEmitter(nil)
                
                // then
                expect(e1.hasValue()) == false
            }
            
            it("synthesizes source with value correctly") {
                // when
                let e1: Source<Int> = sut.synthesizeEmitter(1)
                
                // then
                expect(e1.value()) == 1
            }
            
            it("synthesizes source with value correctly") {
                // when
                let e1: Source<Int> = sut.synthesizeEmitter(1)
                
                // then
                expect(e1.value()) == 1
            }
            
            it("synthesizes a propertyObserver") {
                // when
                let o = sut.synthesizeObserver(FooReactive(), propertyName: "name", initValue: 1)
                
                // then
                expect(o).notTo(beNil())
            }
            
            it("creates an observer") {
                // when
                let o = sut.createObserver(FooReactive(), propertyName: "name", initValue: 1)
                
                // then
                expect(o).notTo(beNil())
            }
            
        }
        
    }
    
}
