VinceRP
======================================
Easy to use, easy to extend reactive framework for Swift.

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Build Status](https://travis-ci.org/bvic23/VinceRP.svg?branch=master)](https://travis-ci.org/bvic23/VinceRP) [![Bitrise](https://www.bitrise.io/app/8eecd50149a499e2.svg?token=NF4ksh3VcIWYouCZPukE1w&branch=master)](https://www.bitrise.io/)
[![codecov.io](http://codecov.io/github/bvic23/VinceRP/coverage.svg?branch=master)](http://codecov.io/github/bvic23/VinceRP?branch=master)
[![MIT License](https://img.shields.io/badge/license-MIT%20License-blue.svg)](LICENSE)

#Getting Started

The framework supports iOS & Mac for now.

##Compatibility

- Swift 2.x
- iOS 8.3 and up
- OS X 10.10 and up

> tvOS and watchOS not yet tested/supported.

##Install with [Carthage](https://github.com/Carthage/Carthage)

1. Add VinceRP to your
[Cartfile](https://github.com/Carthage/Carthage/blob/master/Documentation/Artifacts.md#cartfile): `github "bvic23/VinceRP"`

2. Download and install [the latest Carthage from binary](https://github.com/Carthage/Carthage/releases). (Homebrew is still on 0.8 which is outdated.)

3. Set VinceRP up as a dependency to your project:
`carthage update --platform iOS, Mac`

#Easy to use

Let's see a basic example:

```swift
import VinceRP

// define reactive sources
let s1 = reactive(1)
let s2 = reactive(2)

// define a calculated variable
let sum = definedAs{ s1* + s2* }

// sum* is just a syntactic sugar for sum.value()
print(sum*) // = 3

// s.update(3)
s2 <- 3

print(sum*) // = 4
```

Note that - thanks to Swift's type inference - it figures out the type of the sources and the `sum` as well. So the following won't compile:

```swift
import VinceRP

let s = reactive(1)

let s2 = definedAs{ "s*2 = \(s.value() * 2)" }
let s3 = definedAs{ s2* + s* }
```
However XCode 7.0 (7A218) gives a weird error message (`tuple pattern cannot match values of the non-tuple type 'UIButton'` WTF????) it's about the missing `<string> + <int>` operator.

##Side effects

Of course you can have side effects:

```swift
import VinceRP

let s = reactive(1)
var counter = 0

onChangeDo(s) { _ in
   counter++
}

// 1 because of the initialization
print(counter) // = 1
```

If you don't want to count the initialization:

```swift
import VinceRP

let s = reactive(1)
var counter = 0

onChangeDo(s, skipInitial:true) { _ in
    counter++
}

s <- 2

// 1 because of the update
print(counter) // = 1
```

##Errors

If you're interested in errors:

```swift
import VinceRP

let s = reactive(1)

s.onChange(true) {
    print($0)
}.onError {
    print($0)
}

s <- 2
s <- NSError(domain: "test error", code: 1, userInfo: nil)

// output:
// 2
// Error Domain=test error Code=1 "(null)"
```

#Easy to extend

 It's pretty easy to add reactive properties to UIKit with extensions:

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

#About

VinceRP is in alpha phase so please use it carefully in production and send me [mail](bvic23@gmail.com)/[tweet](@bvic23)/github issue to make me happy and proud! :-)

##Do you miss something?

Add it, ask for it... Any suggestions, bug reports, in the form of [issues](https://github.com/bvic23/VinceRP/issues) and of course [pull requests](https://github.com/bvic23/VinceRP/pulls) are welcome!

##Who is Vince?

[![Vince](https://scontent-vie1-1.cdninstagram.com/hphotos-xaf1/t51.2885-15/e15/10919568_846220368758561_908103058_n.jpg)](http://instagram.com/the_sphynx_and_the_prince)

#References

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

#License

[VinceRP is released under an MIT license.](https://github.com/bvic23/VinceRP/blob/master/LICENSE)
