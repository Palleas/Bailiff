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

    let error = MutableProperty<IssueError?>(nil)

    let selectedProjectIndex = MutableProperty<Int>(-1)
    let issueContent = MutableProperty<String>("")

    lazy var createIssueAction: Action<Void, Issue, IssueError> = { [unowned self] in
        return Action { _ -> SignalProducer<Issue, IssueError> in
            let (title, description) = extractIssueInfo(content: self.issueContent.value)

            return self.issueController.createIssue(self.projects.value[self.selectedProjectIndex.value], title: title, description: description)
        }
    }()

    private let issueController: IssueController

    init(issueController: IssueController) {
        self.issueController = issueController

        let projectsSignalProducer = issueController.projects().collect().flatMapError { (error: IssueError) -> SignalProducer<[Project], NoError> in
            return SignalProducer<[Project], NoError>(value: [])
        }

        projects <~ projectsSignalProducer
    }
}
