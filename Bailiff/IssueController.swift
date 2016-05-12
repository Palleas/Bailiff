//
//  IssueController.swift
//  Bailiff
//
//  Created by Romain Pouclet on 2016-05-09.
//  Copyright © 2016 Perfectly-Cooked. All rights reserved.
//

import Foundation
import Arwing
import ReactiveCocoa

enum IssueError: ErrorType {
    case ClientError(underlyingError: Arwing.ClientError)
}

protocol IssueController {
    func createIssue(project: Project, title: String, description: String) -> SignalProducer<Issue, IssueError>
    func projects() -> SignalProducer<Project, IssueError>
}

class BailiffIssueController: IssueController{

    private let client: Client

    init(client: Client) {
        self.client = client
    }

    func createIssue(project: Project, title: String, description: String) -> SignalProducer<Issue, IssueError> {
        return client
            .createIssue(project, title: title, description: description)
            .mapError { error in return IssueError.ClientError(underlyingError: error) }

    }

    func projects() -> SignalProducer<Project, IssueError> {
        return client.projects().mapError { error in return IssueError.ClientError(underlyingError: error) }
    }

}