//
// Created by Viktor Belényesi on 01/12/15.
// Copyright (c) 2015 Viktor Belenyesi. All rights reserved.
//

public class Incrementing<T>: Hub<T> {
    
    private var _state: AtomicReference<UpdateState<T>>
    
    override init() {
        _state = AtomicReference(UpdateState(Try(noValueError)))
        super.init()
        _state = AtomicReference(self.makeState())
    }
    
    var state: UpdateState<T> {
        return _state.value
    }
    
    func toTry() -> UpdateState<T> {
        return self.state
    }
    
    func makeState() -> UpdateState<T> {
        fatalError(ABSTRACT_METHOD)
    }
    
    override func ping(incoming: Set<Node>) -> Set<Node> {
        let newState = makeState()
        
        if newState.id <= _state.value.id {
            return Set()
        }
        
        if newState.value.description == _state.value.value.description {
            return Set()
        }
        
        _state.value = newState
        return children
    }
    
}
