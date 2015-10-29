//
// Created by Viktor Belenyesi on 18/06/15.
// Copyright (c) 2015 Viktor Belenyesi. All rights reserved.
//

func try2(maker: ()->(()->(), catch2:((NSException!)->())?, finally:(()->())? )) {
    let (action, catch2, finally) = maker()
    VRPNSObjectHelper.try2InvokeBlock(action, catch2: catch2, finally: finally)
}

func try2<T: AnyObject>(maker: ()->( ()->T, catch2:((NSException!)->())?, finally: (()->())? )) -> T? {
    let (action, catch2, finally) = maker()
    let result : AnyObject! = VRPNSObjectHelper.try2InvokeBlockWithReturn(action, catch2: { ex in
        if let catch2Clause = catch2 {
            catch2Clause(ex)
        }
        return nil
        }, finally: finally)
    if (result != nil) {
        return result as? T
    } else {
        return nil
    }
}

func try2<T: AnyObject>(maker: ()->( ()->T, catch2:((NSException!)->T)?, finally: (()->())? )) -> T? {
    let (action, catch2, finally) = maker()
    let result : AnyObject! = VRPNSObjectHelper.try2InvokeBlockWithReturn(action, catch2: catch2, finally: finally)
    if (result != nil) {
        return result as? T
    } else {
        return nil
    }
}

func throw2(name:String, message:String) {
    VRPNSObjectHelper.throwExceptionNamed(name, message: message)
}
