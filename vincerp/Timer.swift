//
// Created by Viktor Belenyesi on 10/18/15.
// Copyright (c) 2015 Viktor Belenyesi. All rights reserved.
//

public class Timer {
    
    private var timer: NSTimer?
    private var tick: (() -> ())?
    
    private init() {}
    
    @objc private func timerHandler() {
        self.tick!()
    }
    
    public func cancel() {
        guard let t = self.timer else {
            return
        }
        t.invalidate()
        self.timer = nil
    }
    
    class func timer(interval: NSTimeInterval, tick: () ->()) -> Timer {
        let result = Timer()
        let t = NSTimer.scheduledTimerWithTimeInterval(interval, target: result, selector: Selector("timerHandler"), userInfo: nil, repeats: true)
        result.tick = tick
        result.timer = t
        return result
    }

}
