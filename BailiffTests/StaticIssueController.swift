//
//  ContentProvider.swift
//  Bailiff
//
//  Created by Romain Pouclet on 2016-05-09.
//  Copyright © 2016 Perfectly-Cooked. All rights reserved.
//

import Foundation
import Arwing
import ReactiveCocoa

class StaticIssueController: IssueController {
    private let list: [Project]
    private let delayInSeconds: Double

    init(count: Int, delayInSeconds: Double = 0.5) {
        self.delayInSeconds = delayInSeconds
        self.list = (0..<count).map { Project(id: $0, name: "project-\($0)", nameWithNamespace: "user/project-\($0)") }
    }

    func projects() -> SignalProducer<Project, IssueError> {
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delayInSeconds * Double(NSEC_PER_SEC)))

        return SignalProducer { sink, _ in

            dispatch_after(delayTime, dispatch_get_main_queue()) {
                self.list.forEach { project in
                    sink.sendNext(project)
                }
                sink.sendCompleted()
            }
            
        }
    }

    func createIssue(project: Project, title: String, description: String) -> SignalProducer<Issue, IssueError> {
        return SignalProducer.empty
    }
}