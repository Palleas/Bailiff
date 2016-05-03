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
    private let client: Client
    private var createIssueWindowController: CreateIssueWindowController
    private let presenter: Presenter

    init(client: Client, presenter: Presenter) {
        self.client = client
        self.presenter = presenter
        self.createIssueWindowController = CreateIssueWindowController(client: client)

        super.init()
    }

    func prepare() -> SignalProducer<Issue, ClientError> {
        presenter.present(controller: createIssueWindowController)

        NSApp.activateIgnoringOtherApps(true)

        return SignalProducer.empty
    }
}
