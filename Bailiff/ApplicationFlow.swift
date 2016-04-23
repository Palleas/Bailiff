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
    private var statusBarItem: NSStatusItem?
    private var client: Client?

    override init() {
        self.onboardingWindowController = OnboardingWindowController(viewModel: onboardingViewModel)

        super.init()
    }

    func start() {
        // TODO: Move onboarding in specific flow
        let keychain = KeychainSwift()
        if let endPointString = keychain.get(ApplicationFlow.EndpointStorageKey), let endpoint = NSURL(string: endPointString), let token = keychain.get(ApplicationFlow.PrivateKeyStorageKey) {
            self.client = Client(provider: TokenAuthentication(token: token), endpoint: endpoint)

            // Show menu item
            let item = NSStatusBar.systemStatusBar().statusItemWithLength(NSSquareStatusItemLength)
            item.image = NSImage(named: "logo-menu")!
            item.image?.template = true
            item.highlightMode = true
            item.menu = self.buildMenu()

            self.statusBarItem = item

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

    private func buildMenu() -> NSMenu {
        let menu = NSMenu(title: "Bailiff")
        menu.addItemWithTitle("Create Issue", action: #selector(didSelectCreateIssue), keyEquivalent: "C")?.target = self
        menu.addItem(NSMenuItem.separatorItem())
        menu.addItemWithTitle("About Bailiff", action: #selector(didSelectAbout), keyEquivalent: "A")?.target = self
        menu.addItemWithTitle("Quit", action: #selector(didSelectQuit), keyEquivalent: "Q")?.target = self

        return menu
    }

    func didSelectCreateIssue() {
        let createIssueFlow = CreateIssueFlow(client: client!)
        createIssueFlow.start()
        self.createIssueFlow = createIssueFlow

    }

    func didSelectAbout() {

    }

    func didSelectQuit() {

    }

}
