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
import KeychainSwift

class ApplicationFlow: NSObject {
    private static let PrivateKeyStorageKey = "com.perfectly-cooked.bailiff.PrivateKeyStorageKey"
    private static let EndpointStorageKey = "EndpointStorageKey"

    private var createIssueFlow: CreateIssueFlow?
    private let onboardingViewModel = OnboardingViewModel()
    private let onboardingWindowController: OnboardingWindowController

    override init() {
        self.onboardingWindowController = OnboardingWindowController(viewModel: onboardingViewModel)

        super.init()
    }

    func start() {
        // TODO: Move onboarding in specific flow
        let keychain = KeychainSwift()
        if let endPointString = keychain.get(ApplicationFlow.EndpointStorageKey), let endpoint = NSURL(string: endPointString), let token = keychain.get(ApplicationFlow.PrivateKeyStorageKey) {
            let client = Client(provider: TokenAuthentication(token: token), endpoint: endpoint)

            let createIssueFlow = CreateIssueFlow(client: client)
            createIssueFlow.start()
            self.createIssueFlow = createIssueFlow

            return
        }

        onboardingWindowController.loadWindow()
        onboardingWindowController.showWindow(nil)
        onboardingWindowController.window?.makeKeyAndOrderFront(self)

        onboardingViewModel.action.values
            .on(next: { client in
                // Store token
                let keychain = KeychainSwift()
                keychain.set(client.provider.rawToken, forKey: ApplicationFlow.PrivateKeyStorageKey)
                // Store endpoint
                keychain.set(client.endpoint.absoluteString, forKey: ApplicationFlow.EndpointStorageKey)
            })
            .observeOn(UIScheduler())
            .observeNext { [weak self] client in
                let createIssueFlow = CreateIssueFlow(client: client)
                createIssueFlow.start()

                self?.createIssueFlow = createIssueFlow
            }
    }
}
