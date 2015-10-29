//
// Created by Viktor Belenyesi on 18/06/15.
// Copyright (c) 2015 Viktor Belenyesi. All rights reserved.
//

#import "VRPNSObjectHelper.h"

#import <objc/runtime.h>
#import <UIKit/UIKit.h>

@implementation VRPNSObjectHelper

+ (void)try2InvokeBlock:(void(^)(void))try2Block catch2:(void(^)(NSException*))catch2Block finally:(void(^)(void))finallyBlock {
    NSAssert(try2Block != NULL, @"try2 block cannot be null");
    NSAssert(catch2Block != NULL || finallyBlock != NULL, @"catch2 or finally block must be provided");
    @try {
        try2Block();
    }
    @catch (NSException *ex) {
        if(catch2Block != NULL) {
            catch2Block(ex);
        }
    }
    @finally {
        if(finallyBlock != NULL) {
            finallyBlock();
        }
    }
}

+ (id)try2InvokeBlockWithReturn:(id(^)(void))try2Block catch2:(id(^)(NSException*))catch2Block finally:(void(^)(void))finallyBlock {
    NSAssert(try2Block != NULL, @"try2 block cannot be null");
    NSAssert(catch2Block != NULL || finallyBlock != NULL, @"catch2 or finally block must be provided");
    
    id returnValue = nil;
    @try {
        returnValue = try2Block();
    }
    @catch (NSException *ex) {
        if(catch2Block != NULL) {
            returnValue = catch2Block(ex);
        }
    }
    @finally {
        if(finallyBlock != NULL) {
            finallyBlock();
        }
    }
    return returnValue;
}

+ (void)throwExceptionNamed:(NSString *)name message:(NSString *)message {
    [NSException raise:name format:@"message:%@", message];
}

@end
