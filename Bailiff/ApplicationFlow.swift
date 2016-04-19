//
//  ApplicationFlow.swift
//  Bailiff
//
//  Created by Romain Pouclet on 2016-04-18.
//  Copyright © 2016 Perfectly-Cooked. All rights reserved.
//

import Cocoa
import ReactiveCocoa
import Arwing

class ApplicationFlow: NSObject {
    private var onboardingWindowController: OnboardingWindowController?
    private var createIssueFlow: CreateIssueFlow?

    func start() {
        let viewModel = OnboardingViewModel()
        let onboardingWindowController = OnboardingWindowController(viewModel: viewModel)

        onboardingWindowController.loadWindow()
        onboardingWindowController.showWindow(nil)
        onboardingWindowController.window?.makeKeyAndOrderFront(self)
        self.onboardingWindowController = onboardingWindowController

        viewModel.action.values
            .observeOn(UIScheduler())
            .promoteErrors(ClientError)
            .observeNext { [unowned self] client in
                self.createIssueFlow = CreateIssueFlow(client: client)
                self.createIssueFlow?.start()
            }

    }
}
