![VinceRP](logoTrimmed.png)

Easy to use, easy to extend reactive framework for Swift.

![Swift 2](https://img.shields.io/badge/language-Swift_2-orange.svg)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Version](https://img.shields.io/cocoapods/v/VinceRP.svg?style=flat)](http://cocoadocs.org/docsets/VinceRP)
[![Platform](https://img.shields.io/cocoapods/p/VinceRP.svg?style=flat)](http://cocoadocs.org/docsets/VinceRP)
[![Build Status](https://travis-ci.org/bvic23/VinceRP.svg?branch=master)](https://travis-ci.org/bvic23/VinceRP) [![Bitrise](https://www.bitrise.io/app/8eecd50149a499e2.svg?token=NF4ksh3VcIWYouCZPukE1w&branch=master)](https://www.bitrise.io/)
[![codecov.io](http://codecov.io/github/bvic23/VinceRP/coverage.svg?branch=master)](http://codecov.io/github/bvic23/VinceRP?branch=master)
[![MIT License](https://img.shields.io/badge/license-MIT%20License-blue.svg)](LICENSE)

# Getting Started

The framework supports iOS & Mac for now.

## Compatibility

- Swift 2.x
- iOS 8.3 and up
- OS X 10.10 and up

> tvOS and watchOS not yet tested/supported.

## Install

### [Carthage](https://github.com/Carthage/Carthage)

1. Add VinceRP to your
[Cartfile](https://github.com/Carthage/Carthage/blob/master/Documentation/Artifacts.md#cartfile): `github "bvic23/VinceRP"`

2. Download and install [the latest Carthage from binary](https://github.com/Carthage/Carthage/releases). (Homebrew is still on 0.8 which is outdated.)

3. Set VinceRP up as a dependency to your project:
`carthage update --platform iOS, Mac`

### [CocoaPods](https://cocoapods.org/)

1. Add VinceRP to your
[Podfile](https://guides.cocoapods.org/syntax/podfile.html): `pod 'VinceRP'`

2. Download and install [CocoaPods](https://guides.cocoapods.org/using/getting-started.html#installation).

3. Run: `pod install`

# Easy to use

Let's see a basic example:

```swift
import VinceRP

// Define reactive sources
// -----------------------
// integer-stream object with a starting value of 1
let s1 = reactive(1)

// integer-stream object with a starting value of 2
let s2 = reactive(2)

// Define a calculated variable
// ----------------------------
// whenever s1 or s2 receives a new value (via the <- operator)
// the value of this variable gets recalculated automagically
// using the the block after 'definedAs'
let sum = definedAs{ s1* + s2* }

// Remember sum* is just a syntactic sugar for sum.value()
// -------------------------------------------------------
// * reads the last / current value of sum
print(sum*) //  3

// Push a new value into the stream
// --------------------------------
// s.update(3)
s2 <- 3

// it recalculates using the block and push a new value into the stream
print(sum*) //  4
```

Note that - thanks to Swift's type inference - it figures out the type of the sources and the `sum` as well. So the following won't compile:

```swift
import VinceRP

let s = reactive(1)

let s2 = definedAs{ "s*2 = \(s.value() * 2)" }
let s3 = definedAs{ s2* + s* }
```
You might see a weird error message but it's all about the missing `<string> + <int>` operator.

## Side effects

Of course you can have side effects:

```swift
import VinceRP

// Define a reactive stream variable
let s = reactive(1)
var counter = 0

// Whenever 's' changes the block gets called
onChangeDo(s) { _ in
   counter++
}

// 1 because of the initialization
print(counter) //  1
```

If you don't want to count the initialization:

```swift
import VinceRP

// Define a reactive stream variable
let s = reactive(1)
var counter = 0

// Whenever 's' changes the block gets called
onChangeDo(s, skipInitial:true) { _ in
    counter++
}

// Push a new value into the stream
s <- 2

// 1 because of the update
print(counter) //  1
```

## Errors

If you're interested in errors:

```swift
import VinceRP

// Define a reactive stream variable
let s = reactive(1)

s.onChange(skipInitial: true) {
    print($0)
}.onError {
    print($0)
}

// Push a new value triggers the 'onChange' block
s <- 2

// Push an error triggers the 'onError' block
s <- NSError(domain: "test error", code: 1, userInfo: nil)

// output:
// 2
// Error Domain=test error Code=1 "(null)"
```

# Operators

### not

It is applicable for `Bool` streams and negates the values.

```swift
// Define a reactive stream variable with 'true' as initial value
let a = reactive(true)

// It's value is true
print(a.value()) //  true

// If you apply the 'not()' operator it negates all the values of the stream
print(a.not().value()) //  false
```

### distinct

```swift
// Define a reactive stream variable with '1' as initial value
let a = reactive(1)

// Define a calculated variable with 'distinct' modifier which ensures it won’t react unless the value has actually changed
let b = a.distinct()

// Let's count the changes of b
let counter = 0
b.onChange(skipInitial: true) { _ in counter++ }

// It's value is 1
print(c) //  0

// If we push an equal (same) value
a <- 1

// c is still 0
print(c) //  0

// If we push a different value
a <- 2

// c becomes 1
print(c) //  1

```

### skipErrors

```swift
// Define a reactive stream variable
let x = reactive(1)

// Define a calculated variable and apply 'skipErrors'
let y = definedAs { x* + 1 }.skipErrors()

// Let's count the number of errors
var count = 0
onErrorDo(y) {  _ in
    count++
}

// When we push an error into x
x <- NSError(domain: "domain.com", code: 1, userInfo: nil)

// Because 'y' ignores errors
print(count) // 0
```

### foreach
```swift
// Define a reactive stream variable with a starting value of 1
let x = reactive(1)

// This array will represent the history of 'x'
var history = [Int]()

// If 'x' receives a new value...
x.foreach {
   history.append($0)
}

// Then
print(history) // [1]

// Push a new value
x <- 2

// Then
print(accu) // [1, 2]
```

### map
```swift
// Define a reactive stream variable with a starting value of 1
let x = reactive(1)

// Define a calculated variable which doubles the values of 'x'
let y = x.map { $0 * 2 }

// Then
print(y) // 2

// Push a new value
x <- 2

// Then
print(y) // 4
```

### mapAll
`mapAll` is a special version of map which operates on [Try<T>](https://github.com/bvic23/VinceRP/blob/master/vincerp/Common/Util/Try.swift), the underlying monad if you want to handle Failures in some special way.

Let's say we would like to have an error if division by zero is happening:

```swift
let numerator = reactive(4)
let denominator = reactive(1)

// Let's create a tuple
let frac = definedAs {
   (numerator*, denominator*)
}.mapAll { (p:Try<(Int, Int)>) -> Try<Int> in
   switch p {
       case .Success(let box):
           let (n, d) = box.value
           if d == 0 {
               return Try(NSError(domain: "division by zero", code: -0, userInfo: nil))
           }
           return Try(n/d)
       case .Failure(let error): return Try(error)
   }
}

// Let's print the errors
frac.onError {
    print($0.domain)
}

// And the changes
frac.onChange {
    print($0.domain)
}

// If we push a 0 to the denominator
denominator <- 0

// Then a non-zero
denominator <- 2

// The output is the following:
// ----------------------------
// divison by zero
// 2
```
### filter

```swift
// Define a reactive stream variable with a starting value of 10
let x = reactive(10)

// Let's pass through values higher than 5
let y = x.filter { $0 > 5 }

// When we push 1
x <- 1

// Value of y will remain the same
print(y*) // 10

// When we push 6
x <- 6

// Value of y will be 6
print(y*) // 6
```

### filterAll
`filterAll` is a special version of map which operates on [Try<T>](https://github.com/bvic23/VinceRP/blob/master/vincerp/Common/Util/Try.swift), the underlying monad if you want to handle Failures in some special way.

Let's implement `skipErrors` in terms of `filterAll`:

```swift
public func skipErrors() -> Hub<T> {
    return filterAll { $0.isSuccess() }
}
```

### reduce

```swift
// Define a reactive stream variable with a starting value of 1
let x = reactive(1)

// Define a calculated variable which sums the values of 'x'
let sum = x.reduce { $0 + $1 }

// When we push 2
x <- 2

// The sum will be 3
print(sum*) // 3

// When we push 3
x <- 3

// The sum will be 6
print(sum*) // 6
```

### reduceAll
`reduceAll` is a special version of map which operates on [Try<T>](https://github.com/bvic23/VinceRP/blob/master/vincerp/Common/Util/Try.swift), the underlying monad if you want to handle Failures in some special way.

```swift
// Define a reactive stream variable with a starting value of 0
let x = reactive(0)

// Let's summarize the values of 'x' and reset the sum to zero if an error arrives
let sum = x.reduceAll { (x, y) in
    switch (x, y) {
    case (.Success(let a), .Success(let b)): return Try(a.value + b.value)
    default: return Try(0)
    }
}

// Initially sum is zero
print(sum*) // 0

// When we push 1
x <- 1

// Then it will be 1
print(sum*) // 1

// When we push 2
x <- 2

// Then the sum will be
print(sum*) // 3

// When we push an error
x <- fakeError

// Then it will reset the sum to zero
print(sum*) == 0

// When we push a non-error
x <- 5

// Then it starts again
expect(sum*) == 5

```

### ignore
`ignore` is simply a filter against a constant value:

```swift
public func ignore(ignorabeValues: T) -> Hub<T> {
    return self.filter { $0 != ignorabeValues }
}

// Define a reactive stream variable with a starting value of 1
let x = reactive(1)

// Define a calculated variable which ignores 0
let y = y.ignore(0)

// When we push a 0
x <- 0

// Then nothing changes
print(y*) // 1

// When we push a non-zero
x <- 5

// Then value of y will be 5
print(y*) // 5
```

### throttle
`throttle` operator buffers an item from the stream and wait for the time span specified by the timeout parameter to expire. If another item is produced from the sequence before the time span expires, Then that item replaces the old item in the buffer and the wait starts over. If the due time does expire before another item is produced in the stream, them that item is observed through any subscriptions to the sequence.

```swift
// Define a reactive stream variable with a starting value of 0
let x = reactive(0)

// Define a calculated variable which passes through values after 1 seconds
let y = x.throttle(1.0)

// When we push 1 to the source
x <- 1

// Then it won't change immediately
print(y*) // 0

// If we wait more than one second
// sleep(2)

// Then it's value will be 1
print(y*) // 1
```

For a better example, check out the [FlickrExample](https://github.com/bvic23/VinceRP/tree/master/examples/BasicExample)

# Easy to extend

It's pretty easy to add reactive properties to UIKit with extensions:

```swift
public extension UILabel {

    public var reactiveText: Rx<String> {
        // When you read the property it returns a stream variable
          get {
            return reactiveProperty(forProperty: "text", initValue: self.text!)
        }

        // It's tricky: we just observers the event stream and if it changes just update the original property
        set {
            newValue.onChange {
                self.text = $0
            }
        }
    }

}
```

As you can see in the more complex [example](https://github.com/bvic23/VinceRP/tree/master/examples/BasicExample) - called BasicExample :-) - you can add your own convenience extensions as well:

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

# About

VinceRP is in alpha phase so please use it carefully in production and push me [mail](bvic23@gmail.com)/[tweet](@bvic23)/github issue to make me happy and proud! :-)

## Do you miss something?

Add it, ask for it... Any suggestions, bug reports, in the form of [issues](https://github.com/bvic23/VinceRP/issues) and of course [pull requests](https://github.com/bvic23/VinceRP/pulls) are welcome!

## Who is Vince?

[![Vince](https://scontent-vie1-1.cdninstagram.com/hphotos-xaf1/t51.2885-15/e15/10919568_846220368758561_908103058_n.jpg)](http://instagram.com/the_sphynx_and_the_prince)

# References

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

# License

[VinceRP is released under an MIT license.](https://github.com/bvic23/VinceRP/blob/master/LICENSE)
