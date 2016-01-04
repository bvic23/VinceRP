//
// Created by Viktor Belenyesi on 18/06/15.
// Copyright (c) 2015 Viktor Belenyesi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VRPNSObjectHelper : NSObject

+ (void)try2InvokeBlock:(void(^)(void))try2Block catch2:(void(^)(NSException*))catch2Block finally:(void(^)(void))finallyBlock;

@end
