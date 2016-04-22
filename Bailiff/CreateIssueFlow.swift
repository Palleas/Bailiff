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
    private var createIssueWindowController: CreateIssueWindowController?

    init(client: Client) {
        self.client = client

        super.init()
        
        let createIssueWindowController = CreateIssueWindowController(client: client)
        self.createIssueWindowController = createIssueWindowController

    }

    func start() {
        guard let createIssueWindowController = createIssueWindowController else { return }

        createIssueWindowController.loadWindow()
        createIssueWindowController.showWindow(nil)
        createIssueWindowController.window?.makeKeyAndOrderFront(self)

        NSApp.activateIgnoringOtherApps(true)
    }
}
