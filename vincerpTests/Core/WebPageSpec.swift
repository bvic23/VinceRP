//
// Created by Viktor Belenyesi on 18/04/15.
// Copyright (c) 2015 Viktor Belenyesi. All rights reserved.
//

@testable import vincerp

import Quick
import Nimble

var fakeTime = 123

class WebPage:Equatable {

    func fTime() -> Int {
        return fakeTime
    }

    func update() -> () {
        time <- fTime()
    }

    lazy var time: Source<Int> = {
        [unowned self] in
        return reactive(self.fTime())
    }()

    func makeHtml() -> Dynamic<String> {
        assert(false, "override me")
    }

    var html: Dynamic<String> {
        return self.makeHtml()
    }

}

func ==(lhs: WebPage, rhs: WebPage) -> Bool {
    return lhs.html == rhs.html
}

class HomePage : WebPage {
    override func makeHtml() -> Dynamic<String> {
        return definedAs {"Home Page! time: \(self.time*)"}
    }
}

class AboutPage : WebPage {
    override func makeHtml() -> Dynamic<String> {
        return definedAs {"About Me, time: \(self.time*)"}
    }
}

class WebPageSpec: QuickSpec {

    override func spec() {

        it("works with cascaded reactives") {
            // given
            let url = reactive("www.mysite.com/home")
            let page = definedAs { () -> WebPage in
                switch url* {
                    case "www.mysite.com/home": return HomePage()
                    case "www.mysite.com/about": return AboutPage()
                    default: assert(false, "should never happen")
                }
            }

            // then
            expect(page*.html*) == "Home Page! time: 123"

            // when
            fakeTime = 234
            page*.update()

            // then
            expect(page*.html*) == "Home Page! time: 234"

            // when
            fakeTime = 345
            url <- "www.mysite.com/about"

            // then
            expect(page*.html*) == "About Me, time: 345"

            // when
            fakeTime = 456
            page*.update()

            // then
            expect(page*.html*) == "About Me, time: 456"
        }

    }

}
