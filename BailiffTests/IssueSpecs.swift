//
//  IssueSpecs.swift
//  Bailiff
//
//  Created by Romain Pouclet on 2016-05-05.
//  Copyright © 2016 Perfectly-Cooked. All rights reserved.
//

import XCTest
import Quick
import Nimble

class IssueSpecs: QuickSpec {

    override func spec() {
        describe("Issues Helpers") {
            it("contains a big chunk of text") {
                let issueContent = "Bailiff doesn't support gitlab.com community account\n"
                    + "\n"
                    + "To be honnest it should\n"

                let (title, content) = extractIssueInfo(content: issueContent)
                expect(title).to(equal("Bailiff doesn't support gitlab.com community account"))
                expect(content).to(equal("To be honnest it should"))
            }

            it("contains a single line of text") {
                let issueContent = "Bailiff doesn't support gitlab.com community account"

                let (title, content) = extractIssueInfo(content: issueContent)
                expect(title).to(equal("Bailiff doesn't support gitlab.com community account"))
                expect(content).to(beNil())
            }
        }
    }

}
