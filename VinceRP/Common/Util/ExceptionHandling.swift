//
// Created by Viktor Belenyesi on 18/06/15.
// Copyright (c) 2015 Viktor Belenyesi. All rights reserved.
//

func try2(maker: ()->(()->(), catch2:((NSException!)->())?, finally:(()->())? )) {
    let (action, catch2, finally) = maker()
    VRPNSObjectHelper.try2InvokeBlock(action, catch2: catch2, finally: finally)
}
