//
// Created by Viktor Belenyesi on 21/04/15.
// Copyright (c) 2015 Viktor Belenyesi. All rights reserved.
//

extension Dictionary {

    init<S:SequenceType where S.Generator.Element == Element>(_ seq: S) {
        self.init()
        for (k, v) in seq {
            self[k] = v
        }
    }

    public func mapValues<S>(transform: Value -> S) -> Dictionary<Key, S> {
        return Dictionary<Key, S>(zip(self.keys, self.values.map(transform)))
    }

    public func map<S>(transform: (Key, Value) -> S) -> Set<S> {
        var results: Set<S> = Set()
        for k in self.keys {
            guard let v = self[k] else {
                continue
            }
            results.insert(transform(k, v))
        }
        return results
    }

}
