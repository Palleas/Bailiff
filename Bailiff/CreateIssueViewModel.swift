//
//  CreateIssueViewModel.swift
//  Bailiff
//
//  Created by Romain Pouclet on 2016-05-03.
//  Copyright © 2016 Perfectly-Cooked. All rights reserved.
//

import Cocoa
import Result
import ReactiveCocoa
import Arwing

class CreateIssueViewModel {

    let projects = MutableProperty([Project]())

    let selectedProject = MutableProperty<Project?>(nil)
    let issueContent = MutableProperty<String?>(nil)
    let createdIssue = MutableProperty<Issue?>(nil)
    let issueCreationError = MutableProperty<CreateIssueError?>(nil)
    
    private let client: Client
    init(client: Client) {
        self.client = client

        projects <~ client.projects().collect().flatMapError({ _ in SignalProducer<[Project], NoError>(value: []) })

        selectedProject.producer.ignoreNil().zipWith(issueContent.producer.ignoreNil())
            .promoteErrors(CreateIssueError.self)
            .flatMap(.Latest, transform: { (project, string) -> SignalProducer<Issue, CreateIssueError> in
                return self.client
                    .createIssue(project, title: "My Issue", description: "Content")
                    .mapError { _ in CreateIssueError.InternalError }
            })
            .on(failed: { [weak self] error in
                self?.issueCreationError.value = error
            })
            .startWithNext() { issue in
                print("Created issue: \(issue)")
            }
    }
}
