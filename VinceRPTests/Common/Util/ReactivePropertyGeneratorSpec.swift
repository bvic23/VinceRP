//
// Created by Viktor Belényesi on 04/01/16.
// Copyright (c) 2016 Viktor Belenyesi. All rights reserved.
//

@testable import VinceRP

import Quick
import Nimble

/*
    static func getKey(targetObject: AnyObject, propertyName: String) -> String {
    static func getEmitter<T>(targetObject: AnyObject, propertyName: String) -> Source<T>? {
    static func synthesizeEmitter<T>(initValue: T?) -> Source<T> {
    static func synthesizeObserver<T>(targetObject: AnyObject, propertyName: String, initValue: T?) -> PropertyObserver {
    static func createEmitter<T>(targetObject: AnyObject, propertyName: String, initValue: T?) -> Source<T> {
    static func createObserver<T>(targetObject: AnyObject, propertyName: String, initValue: T?) -> PropertyObserver {
    public static func source<T>(targetObject: AnyObject, propertyName: String, initValue: T?, initializer: ((Source<T>) -> ())? = nil) -> Source<T> {
    public static func property<T>(targetObject: AnyObject, propertyName: String, initValue: T?, initializer: ((Source<T>) -> ())? = nil) -> Hub<T> {
*/

class ReactivePropertyGeneratorSpec: QuickSpec {
    
    override func spec() {
        
        describe("basic") {
            
            it("maps empty dic to empty dic") {
                // when
                let key = ReactivePropertyGenerator.getKey(Foo(), propertyName: "bar")
                
                // then
                expect(key) == "1bar"
            }
            
        }
        
    }
    
}
