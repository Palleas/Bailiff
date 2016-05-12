//
//  CreateIssueFlow.swift
//  Bailiff
//
//  Created by Romain Pouclet on 2016-04-18.
//  Copyright © 2016 Perfectly-Cooked. All rights reserved.
//

import Cocoa
import ReactiveCocoa
import Arwing
import KeychainSwift

class CreateIssueFlow: NSObject {
    private var createIssueWindowController: CreateIssueWindowController
    private let presenter: Presenter
    private let viewModel: CreateIssueViewModel

    init(issueController: IssueController, presenter: Presenter) {
        self.presenter = presenter
        self.viewModel = CreateIssueViewModel(issueController: issueController)
        self.createIssueWindowController = CreateIssueWindowController(viewModel: viewModel)

        super.init()
    }

    func prepare() -> SignalProducer<Issue, ClientError> {
        presenter.present(controller: createIssueWindowController)

        NSApp.activateIgnoringOtherApps(true)

        return SignalProducer.empty
    }
}
