//
// Created by Viktor Belenyesi on 21/04/15.
// Copyright (c) 2015 Viktor Belenyesi. All rights reserved.
//

import vincerp

import Quick
import Nimble

class FunctionalSetSpec: QuickSpec {

    override func spec() {

        context("filter") {

            it("filters something") {
                // given
                let s = toSet(1, 2, 3)

                // when
                let r = s.filter{$0 > 2}

                // then
                expect(r) == toSet(3)
            }

            it("filters nothing") {
                // given
                let s = toSet(1, 2, 3)
                
                // when
                let r = s.filter{$0 > 3}
                
                // then
                expect(r.count) == 0
            }
            
        }

        context("foreach") {

            it("does nothing on empty set") {
                // given
                var r = 0
                let s = Set<Int>()

                // when
                s.forEach {r = r + $0}

                // then
                expect(r) == 0
            }

            it("sums the members of the set") {
                // given
                var r = 0
                let s = toSet(1, 2, 3)

                // when
                s.forEach {r = r + $0}

                // then
                expect(r) == 6
            }

        }

        context("exists") {
            
            it("finds if exists") {
                // given
                let s = toSet(1, 2, 3)
                
                // when
                let r = s.exists{$0 > 2}
                
                // then
                expect(r) == true
            }
            
            it("finds nothing") {
                // given
                let s = toSet(1, 2, 3)
                
                // when
                let r = s.exists{$0 > 3}
                
                // then
                expect(r) == false
            }
            
        }

        context("map") {

            it("maps empty to empty") {
                // given
                let s = Set<Int>()

                // when
                let r = s.map{$0 * 2}

                // then
                expect(r.count) == 0
            }

            it("maps every item") {
                // given
                let s = toSet(1, 2, 3)

                // when
                let r = s.map{$0 * 2}

                // then
                expect(r) == toSet(2, 4, 6)
            }

        }

        context("min") {

            it("returns 0 if empty set") {
                // given
                let s: Set<Int> = Set<Int>()

                // when
                let r = s.min(0)

                // then
                expect(r) == 0
            }

            it("maps every item") {
                // given
                let s: Set<Int> = toSet(3, 1, 2)

                // when
                let r = s.min(0)

                // then
                expect(r) == 1
            }

        }

        context("partition") {

            it("returns empty tuple of sets if empty set") {
                // given
                let s = Set<Int>()

                // when
                let (r1, r2) = s.partition{$0 % 2 == 0}

                // then
                expect(r1.count) == 0
                expect(r2.count) == 0
            }

            it("returns 2 sets") {
                // given
                let s = toSet(3, 1, 2)

                // when
                let (r1, r2) = s.partition{$0 % 2 == 0}

                // then
                expect(r1) == toSet(2)
                expect(r2) == toSet(1, 3)
            }

        }


        context("groupBy") {

            it("returns emptyMap if empty map") {
                // given
                let s = Set<Int>()

                // when
                let r = s.groupBy{$0 % 2}

                // then
                expect(r.count) == 0
            }

            it("returns 2 sets") {
                // given
                let s = toSet(3, 1, 2)

                // when
                let r = s.groupBy{$0 % 2}

                // then
                expect(r) == [0 : toSet(2), 1 : toSet(1, 3)]
            }

        }

        context("flattenMap") {

            it("flattens empty set to empty set") {
                // given
                let s = Set<Int>()

                // when
                let r = s.flatMap{c in toSet(c)}

                // then
                expect(r.count) == 0
            }

            it("flattens flat set to flat set") {
                // given
                let s = toSet(3, 1, 2)

                // when
                let r = s.flatMap{c in toSet(c * 2)}

                // then
                expect(r) == toSet(6, 4, 2)
            }

            it("flattens two level set to flat set") {
                // given
                let s = toSet(toSet(3, 1, 2), toSet(4, 5, 3))

                // when
                let r = s.flatMap{c in c}

                // then
                expect(r) == toSet(1, 2, 3, 4, 5)
            }

        }

        context("flatten") {

            it("flattens empty set to empty set") {
                // given
                let s = Set<Int>()

                // when
                let r = s.flatten()

                // then
                expect(r.count) == 0
            }

            it("flattens flat set to flat set") {
                // given
                let s = toSet(3, 1, 2)

                // when
                let r = s.flatten()

                // then
                expect(r) == toSet(3, 2, 1)
            }

            it("flattens two level set to flat set") {
                // given
                let s = toSet(toSet(3, 1, 2), toSet(4, 5, 3))

                // when
                let r = s.flatten()

                // then
                expect(r) == toSet(1, 2, 3, 4, 5)
            }

        }

    }

}
