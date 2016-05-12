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
    let issueCreationError = MutableProperty<IssueError?>(nil)
    
    private let issueController: IssueController
    init(issueController: IssueController) {
        self.issueController = issueController

        projects.signal.observeNext { value in print("Projects now conains \(value.count) projects") }

        let projectsSignalProducer = issueController.projects().collect().flatMapError { (error: IssueError) -> SignalProducer<[Project], NoError> in
            return SignalProducer<[Project], NoError>(value: [])
        }
        
//        projectsSignalProducer.startWithNext { projects in
//            self.projects.value = projects
//        }


        projects <~ projectsSignalProducer

        selectedProject.producer.ignoreNil().zipWith(issueContent.producer.ignoreNil())
            .promoteErrors(IssueError.self)
            .flatMap(.Latest, transform: { (project, string) -> SignalProducer<Issue, IssueError> in
                let (title, description) = extractIssueInfo(content: string)
                return self.issueController.createIssue(project, title: title, description: description ?? "")
            })
            .on(failed: { [weak self] error in
                self?.issueCreationError.value = error
            })
            .startWithNext() { issue in
                print("Created issue: \(issue)")
            }
    }
}
