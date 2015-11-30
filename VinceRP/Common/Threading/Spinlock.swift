//
//  Created by Viktor Belenyesi on 11/30/15.
//  Copyright © 2015 Viktor Belenyesi. All rights reserved.
//

class Spinlock {
    private var lock: OSSpinLock = OS_SPINLOCK_INIT
    
    func around(code: Void -> Void) {
        OSSpinLockLock(&lock)
        code()
        OSSpinLockUnlock(&lock)
    }
    
    func around<T>(code: Void -> T) -> T {
        OSSpinLockLock(&lock)
        let result = code()
        OSSpinLockUnlock(&lock)
        
        return result
    } 
} 

