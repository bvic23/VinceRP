//
// Created by Viktor Belenyesi on 25/09/15.
// Copyright (c) 2015 Viktor Belenyesi. All rights reserved.
//

public class ReactivePropertyGenerator {

    static let instance = ReactivePropertyGenerator()

    private var propertyMap = [String: Node]()
    private var observerMap = [String: PropertyObserver]()
    
    func getKey(targetObject: AnyObject, propertyName: String) -> String {
        return "\(targetObject.hashValue)\(propertyName)"
    }

    func getEmitter<T>(targetObject: AnyObject, propertyName: String) -> Source<T>? {
        let key = getKey(targetObject, propertyName: propertyName)
        return propertyMap[key] as! Source<T>?
    }

    func synthesizeEmitter<T>(initValue: T?) -> Source<T> {
        guard let i = initValue else {
            return Source<T>()
        }
        return Source<T>(initValue: i)
    }

    func synthesizeObserver<T>(targetObject: AnyObject, propertyName: String, initValue: T?) -> PropertyObserver {
        return PropertyObserver(targetObject: targetObject as! NSObject, propertyName: propertyName) { (currentTargetObject: NSObject, currentPropertyName:String, currentValue:AnyObject)  in
            if let existingEmitter: Source<T> = self.getEmitter(currentTargetObject, propertyName: propertyName) {
                existingEmitter.update(currentValue as! T)
            }
        }
    }

    func createEmitter<T>(targetObject: AnyObject, propertyName: String, initValue: T?) -> Source<T> {
        let result = synthesizeEmitter(initValue)
        let key = getKey(targetObject, propertyName: propertyName)
        propertyMap[key] = result
        return result
    }

    func createObserver<T>(targetObject: AnyObject, propertyName: String, initValue: T?) -> PropertyObserver {
        let result = synthesizeObserver(targetObject, propertyName: propertyName, initValue: initValue)
        let key = getKey(targetObject, propertyName: propertyName)
        observerMap[key] = result
        return result
    }

    public func source<T>(targetObject: AnyObject, propertyName: String, initValue: T?, initializer: ((Source<T>) -> ())? = nil) -> Source<T> {
        if let emitter:Source<T> = getEmitter(targetObject, propertyName: propertyName) {
            return emitter
        }

        let emitter = createEmitter(targetObject, propertyName: propertyName, initValue: initValue)
        if let i = initializer {
            i(emitter)
        }
        return emitter
    }

    public func property<T>(targetObject: AnyObject, propertyName: String, initValue: T?, initializer: ((Source<T>) -> ())? = nil) -> Hub<T> {
        let result = source(targetObject, propertyName: propertyName, initValue: initValue, initializer: initializer)
        createObserver(targetObject, propertyName: propertyName, initValue: initValue)
        return result as Hub<T>
    }
    
}
