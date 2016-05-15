//
//  ErroringIssueController.swift
//  Bailiff
//
//  Created by Romain Pouclet on 2016-05-11.
//  Copyright © 2016 Perfectly-Cooked. All rights reserved.
//

import Foundation
import ReactiveCocoa
import Arwing

class ErroringIssueController: IssueController {
    private let error: IssueError

    init(error: IssueError) {
        self.error = error
    }

    func createIssue(project: Project, title: String, description: String?) -> SignalProducer<Issue, IssueError> {
        return SignalProducer(error: error)
    }

    func projects() -> SignalProducer<Project, IssueError> {
        return SignalProducer.empty
    }
}