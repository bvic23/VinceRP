//
// Created by Viktor Belenyesi on 18/04/15.
// Copyright (c) 2015 Viktor Belenyesi. All rights reserved.
//

let globalDynamic: DynamicVariable<(Node, Array<Node>)> = DynamicVariable(nil)

public class Dynamic<T>: Incrementing<T> {
    private let calc: () -> T
    
    public init(calc: () -> T) {
        self.calc = calc
        super.init()
    }
    
    override func makeState() -> UpdateState<T> {
        let startID = nextID()

        let (newValue, deps): (Try<T>, Array<Node>) = globalDynamic.withValue((self, [])) {
            let calcResult = self.probe(self.calc)
            guard let deps = globalDynamic.value?.1 else {
                return (calcResult, [])
            }
            return (calcResult, deps)
        }

        let levels = Set(deps.map {
            $0.level
        })

        let level = levels.max(0)
        
        return UpdateState(Set(deps), level, startID, newValue)
    }
    
    func probe(calc: () -> T) ->Try<T> {
        var result: Try<T>?
        try2 {
            ({
                result = Try(calc())
            },
            catch2: { e in
                if let ex = e {
                    if let e = ex.userInfo!["error"] as? NSError {
                        result = Try(e)
                    }
                }
            },
            finally: {
                
            })
        }
        return result!
    }

    override func ping(incoming: Set<Node>) -> Set<Node> {
        guard !parents.intersect(incoming).isEmpty || incoming.contains(self) else {
            return Set()
        }
        return super.ping(incoming)
    }

    override public func toTry() -> Try<T> {
        return self.state.value
    }
    
    override func isSuccess() -> Bool {
        return self.state.value.isSuccess()
    }

    override public var parents: Set<Node> {
        return state.parents
    }

    override var level: long {
        return state.level
    }

}


