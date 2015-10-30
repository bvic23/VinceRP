VinceRP
======================================
An easy to use, easy to extend reactive framework for Swift.

Getting Started
-----------------
1. `brew install carthage`
2. `carthage update --platform ios`

OS X, tvOS and watchOS not yet tested/supported.

Easy to use
-------------
Let's see a basic example:

```swift
import vincerp

// define reactive sources
let source1 = reactive(1)
let source2 = reactive(2)

// define a calculated variable
let sum = definedAs{ source1* + source2* }

// sum* is just a syntactic sugar for sum.value()
print(sum*) // = 3

source2 <- 3

print(sum*) // = 4
```

Note that - thanks to Swift's type inference - it figures out the type of the sources and the `sum` as well. So the following won't compile:

```swift
import vincerp

let source = reactive(1)

let doubleSource = definedAs{ "double source = \(source* * 2)" }
let tripleSource = definedAs{ doubleSource* + source* }
```
However XCode 7.0 (7A218) gives a weird error message (`tuple pattern cannot match values of the non-tuple type 'UIButton'` WTF????) it's about the missing `<string> + <int>` operator.

Of course you can have side effects:

```swift
import vincerp

let source = reactive(1)
var counter = 0

let observer = onChangeDo(source) { _ in
    counter++
}

// 1 because of the initalization
print(counter) // = 1
```

If you don't want to count the initialization:

```swift
import vincerp

let source = reactive(1)
var counter = 0

let observer = onChangeDo(source, skipInitial:true) { _ in
    counter++
}

source <- 2

// 1 because of the update
print(counter) // = 1
```

If you're interested in errors:

```swift
import vincerp

let source = reactive(1)

source.onChange(true) { v in
    print(v)
}.onError { e in
    print(e)
}

source <- 2
source <- NSError(domain: "test error", code: 1, userInfo: nil)

// output:
// 2
// Error Domain=test error Code=1 "(null)"
```

Easy to extend
-------------

 It's pretty easy to add UKit extensions using the amazing [ReactivePropertyGenerator](https://github.com/bvic23/VinceRP/blob/master/vincerp/Util/ReactivePropertyGenerator.swift) :

```swift
public extension UILabel {

    public var reactiveText: Rx<String> {
        get {
            return reactiveProperty(forProperty: "text", initValue: self.text!)
        }

        set {
            newValue.onChange {
                self.text = $0
            }
        }
    }

}
```

As you can see in the more complex [example](https://github.com/bvic23/VinceRP/tree/master/examples/BasicExample)  - called BasicExample :-) - you can add your own convenience extensions as well:

```swift
extension UITextField {

    var isValidEmail: Bool {
        return definedAs {
            let range = self.reactiveText.value().rangeOfString(emailRegEx, options:.RegularExpressionSearch)
            return range != nil
        }*
    }

    var isValidPassword: Bool {
        return definedAs {
            self.reactiveText*.trim().length > 0
        }*
    }

}
```

Whenever the value of the `reactiveText` property changes it recalculates the value of `isValidEmail` property automagically.

Build the example
-----------------
1. `brew install carthage`
2. `cd examples/BasicExample`
3. `carthage update --platform ios`

OS X, tvOS and watchOS not yet tested/supported.

Present
---------

VinceRP is in alpha phase so please use it carefully in production and send me [mail](bvic23@gmail.com)/[tweet](@bvic23)/github issue to make me happy and proud! :-)

Future
------
* Add carthage support
* Add more tests
* Add more operators
* Replace Obj-C based try/catch with the [Switf 2.0 version](https://www.bignerdranch.com/blog/error-handling-in-swift-2/)
* [Travis](https://travis-ci.org/) integration

Do you miss something?
------
Add it, ask for it... Any suggestions, bugreports, pull-requests are welcome!

Who is Vince?
------
[![Vince](https://scontent-vie1-1.cdninstagram.com/hphotos-xaf1/t51.2885-15/e15/10919568_846220368758561_908103058_n.jpg)](http://instagram.com/the_sphynx_and_the_prince)

References
------
* [Reactive Extensions](https://msdn.microsoft.com/en-us/data/gg577609.aspx)
* [RxJava](https://github.com/ReactiveX/RxJava)
* [RxScala](https://github.com/ReactiveX/RxScala)
* [Elm](http://elm-lang.org/)
* [Reactive Programming at Netflix](http://techblog.netflix.com/2013/01/reactive-programming-at-netflix.html)
* [Scala React](https://github.com/ingoem/scala-react)
* [nafg/reactive](https://github.com/nafg/reactive)
* [RxSwift](https://github.com/ReactiveX/RxSwift)
* [ScalaJS-React](https://github.com/japgolly/scalajs-react)
* [Immutable Models on iOS](https://www.youtube.com/watch?v=DK3vO3fUnlo)
* [ReactiveCocoa](https://github.com/ReactiveCocoa/ReactiveCocoa)
* [RACify Non-Reactive Code](https://www.youtube.com/watch?v=sek0ohbboNU)
* [React Native](https://facebook.github.io/react-native/)
* [Erik Meijer (Wikipedia)](http://en.wikipedia.org/wiki/Erik_Meijer_%28computer_scientist%29)
* [Rx standard sequence operators visualized (visualization tool)](http://rxmarbles.com/)
* [Deprecating the Observer Pattern](http://infoscience.epfl.ch/record/176887/files/DeprecatingObservers2012.pdf)
* [FRP](https://github.com/ReactiveCocoa/ReactiveCocoa)
* [AllTheFlow](https://blog.alltheflow.com/)
* [ReactiveCocoa vs RxSwift](http://stackoverflow.com/questions/32542846/reactivecocoa-vs-rxswift-pros-and-cons/32581824#32581824)
* [iOSFRP](https://leanpub.com/iosfrp)
* [Protocol-Oriented Programming with UIKit](http://www.captechconsulting.com/blogs/ios-9-tutorial-series-protocol-oriented-programming-with-uikit)
* [Mixins and Traits in Swift 2.0](http://matthijshollemans.com/2015/07/22/mixins-and-traits-in-swift-2/)
* [Controlling Complexity in Swift](https://realm.io/news/andy-matuschak-controlling-complexity/)
* [ReactKit](https://github.com/ReactKit/ReactKit)

License
-------
[VinceRP is released under an MIT license.](https://github.com/bvic23/VinceRP/blob/master/LICENSE.md)
