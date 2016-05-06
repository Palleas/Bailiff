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
            var client: Client!

            beforeEach {
                client = Client(provider: TokenAuthentication(token: "private-key"), endpoint: NSURL(string: "http://gitlab.compamy.com")!)
            }

            it("should expose an error when the content is invalid") {
                let viewModel = CreateIssueViewModel(client: client)
            }
        }
    }
}
