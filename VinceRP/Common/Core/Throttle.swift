//
// Created by Viktor Belenyesi on 16/10/15.
// Copyright (c) 2015 Viktor Belenyesi. All rights reserved.
//

class Throttle<T>: Dynamic<T> {
    
    private let interval: NSTimeInterval
    private let debounceLevel: long
    private var timer: NSTimer?
    private var incoming: Set<Node>
    
    init(source: Hub<T>, interval: NSTimeInterval) {
        self.interval = interval
        self.debounceLevel = source.level + 1
        self.incoming = Set()
        super.init {
            source.value()
        }
    }
    
    func callSelectorAsync(selector: Selector, object: AnyObject?, delay: NSTimeInterval) -> NSTimer {
        return NSTimer.scheduledTimerWithTimeInterval(delay, target: self, selector: selector, userInfo: object, repeats: false)
    }
    
    @objc func pingAsync() {
        if super.ping(incoming).count > 0 {
            propagate()
        }
    }
    
    func getTimer() -> NSTimer? {
        return self.timer
    }
    
    override func ping(incoming: Set<Node>) -> Set<Node> {
        self.incoming = incoming
        if let t = self.timer {
            t.invalidate()
            self.timer = nil
        }
        self.timer = callSelectorAsync(#selector(Throttle.pingAsync), object:nil, delay: self.interval)
        return Set()
    }
    
    override var level: long {
        return self.debounceLevel
    }
}

public extension Hub {
    
    public func throttle(interval: NSTimeInterval) -> Hub<T> {
        return Throttle(source: self, interval: interval)
    }
    
}
