//
// Created by Viktor Belenyesi on 30/11/15.
// Copyright (c) 2015 Viktor Belenyesi. All rights reserved.
//
// Inspired by https://gist.github.com/RuiAAPeres/839ddefe499c96aa35ce
// run: carthage bootstrap --platform mac

import XCTest

import Bond
import Interstellar
import ReactiveCocoa
import RxSwift
import VinceRP

class Performance: XCTestCase {
    
    let testIteration1 = 10000
    
    /// 0.143s (5% stdev)
    func test_measure_ReactiveCocoa_1() {
        
        
        measureBlock {
            
            var counter : Int = 0
            
            let (signal, observer) = ReactiveCocoa.Signal<Int, NoError>.pipe()
            
            
            signal.observeNext { counter += $0 }
            
            for i in 1..<self.testIteration1 {
                observer.sendNext(i)
            }
        }
    }
    
    /// 0.211s (3% stdev)
    func test_measure_Bond_1() {
        
        
        measureBlock {
            
            var counter : Int = 0
            
            let observable = Observable(0)
            
            observable.observe { counter += $0 }
            
            for i in 1..<self.testIteration1 {
                observable.next(i)
            }
        }
    }
    
    // 0.131s (3% stdev)
    func test_measure_Interstellar_1() {
        
        
        measureBlock {
            
            var counter : Int = 0
            
            let signal = Interstellar.Signal<Int>()
            
            signal.next { counter += $0 }
            
            for i in 1..<self.testIteration1 {
                signal.update(i)
            }
        }
    }
    
    // 0.049s (5% stdev)
    func test_measure_RXSwift_1() {
        
        
        measureBlock {
            
            var counter : Int = 0
            
            let observable = Variable(0)
            
            let _ = observable.subscribeNext { counter += $0 }
            
            for i in 1..<self.testIteration1 {
                observable.value = i
            }
        }
    }
    
    
    func test_measure_VinceRP_1() {
        Propagator.async = true
        
        measureBlock {

            var counter = 0
            
            let observable = reactive(0)
            
            let _ = observable.onChange { counter += $0 }
            
            for i in 1..<self.testIteration1 {
                observable <- i
            }
        }
    }

    /*
    
    ////////////////////////////////////////////
    
    
    // 1.279s (2% stdev)
    func test_measure_ReactiveCocoa_2() {
        
        
        measureBlock {
            
            var counter : Int = 0
            
            let (signal, observer) = ReactiveCocoa.Signal<Int, NoError>.pipe()
            
            
            for _ in 1..<30 {
                signal.observeNext { counter += $0 }
            }
            
            for i in 1..<100000 {
                observer.sendNext(i)
            }
        }
    }
    
    // 4.298s (3% stdev)
    func test_measure_Bond_2() {
        
        
        measureBlock {
            
            var counter : Int = 0
            
            let observable = Observable(0)
            
            for _ in 1..<30 {
                observable.observe { counter += $0 }
            }
            
            for i in 1..<100000 {
                observable.next(i)
            }
        }
    }
    
    // 1.812s (15% stdev)
    func test_measure_Interstellar_2() {
        
        
        measureBlock {
            
            var counter : Int = 0
            
            let signal = Interstellar.Signal<Int>()
            
            for _ in 1..<30 {
                signal.next { counter += $0 }
            }
            
            for i in 1..<100000 {
                signal.update(i)
            }
        }
    }
    
    // 1.228s (11% stdev)
    func test_measure_RXSwift_2() {
        
        
        measureBlock {
            
            var counter : Int = 0
            
            let observable = Variable(0)
            
            for _ in 1..<30 {
                let _ = observable.subscribeNext { counter += $0 }
            }
            
            for i in 1..<100000 {
                observable.value = i
            }
        }
    }
    
    ////////////////////////////////////////////
    
    
    // 7.045s (1% stdev)
    func test_measure_ReactiveCocoa_3() {
        
        
        measureBlock {
            
            let (signal, observer) = ReactiveCocoa.Signal<Int, NoError>.pipe()
            
            
            for _ in 1..<30 {
                signal.filter{ $0%2 == 0}.map(String.init).observeNext {_ in }
            }
            
            for i in 1..<100000 {
                observer.sendNext(i)
            }
        }
    }
    
    // 11.283s (2% stdev)
    func test_measure_Bond_3() {
        
        
        measureBlock {
            
            let observable = Observable(0)
            
            for _ in 1..<30 {
                observable.filter{ $0%2 == 0}.map(String.init).observe { _ in }
            }
            
            for i in 1..<100000 {
                observable.next(i)
            }
        }
    }
    
    // 6.530s (1% stdev)
    func test_measure_Interstellar_3() {
        
        
        measureBlock {
            
            let signal = Interstellar.Signal<Int>()
            
            for _ in 1..<30 {
                signal.filter{ $0%2 == 0}.map(String.init).next {_ in }
            }
            
            for i in 1..<100000 {
                signal.update(i)
            }
        }
    }
    
    // 2.198s (3% stdev)
    func test_measure_RXSwift_3() {
        
        
        measureBlock {
            
            
            let observable = Variable(0)
            
            for _ in 1..<30 {
                let _ = observable.filter{ $0%2 == 0}.map(String.init).subscribeNext {_ in  }
            }
            
            for i in 1..<100000 {
                observable.value = i
            }
        }
    }
    */
}
