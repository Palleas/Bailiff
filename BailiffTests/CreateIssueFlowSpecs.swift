//
//  CreateIssueFlowSpecs.swift
//  Bailiff
//
//  Created by Romain Pouclet on 2016-05-03.
//  Copyright © 2016 Perfectly-Cooked. All rights reserved.
//

import Cocoa
import Arwing
import Quick
import Nimble
import OHHTTPStubs

class CreateIssueFlowSpecs: QuickSpec {

    override func spec() {
        describe("The onboarding flow spec") {
            var presenter: CounterPresenter!
            var client: Client!

            beforeEach() {
                presenter = CounterPresenter()
                client = Client(provider: TokenAuthentication(token: "private-key"), endpoint: NSURL(string: "http://gitlab.company.com")!)
            }

            context("User starts creating an issue") {
                it("should present the window") {
                    let flow = CreateIssueFlow(issueController: StaticIssueController(count: 5), presenter: presenter)
                    waitUntil() { done in

                        presenter.presentationCount.producer.skip(1).startWithNext() { presentationCount in
                            expect(presentationCount).to(equal(1))
                            done()
                        }

                        flow.prepare().start()
                    }
                }
            }
        }
    }
}
