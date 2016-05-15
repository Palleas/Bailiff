//
//  CreateIssueViewModelSpecs.swift
//  Bailiff
//
//  Created by Romain Pouclet on 2016-05-05.
//  Copyright © 2016 Perfectly-Cooked. All rights reserved.
//

import XCTest
import Quick
import Nimble
import Arwing


class CreateIssueViewModelSpecs: QuickSpec {

    override func spec() {
        describe("The view model exposed to the create issue flow") {
            var staticIssueController: IssueController!

            beforeEach {
                staticIssueController = StaticIssueController(count: 5)
            }

            it("should fetch the projects") {
                let viewModel = CreateIssueViewModel(issueController: staticIssueController)

                waitUntil(timeout: 5) { done in
                    viewModel.projects.producer.skip(1).startWithNext { projects in
                        expect(projects.count).to(equal(5))
                        done()
                    }
                }
            }
        }
    }
}
