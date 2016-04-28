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
    static let PrivateKeyStorageKey = "com.perfectly-cooked.bailiff.PrivateKeyStorageKey"
    static let EndpointStorageKey = "com.perfectly-cooked.bailiff.EndpointStorageKey"

    private var createIssueFlow: CreateIssueFlow?
    private var statusBarItem: NSStatusItem?
    private var client = MutableProperty<Client?>(nil)

    func start() {
        let onboarding = OnboardingFlow()
        onboarding.prepare().startWithNext() { [weak self] client in
            self?.client.value = client
        }

        client.producer.ignoreNil().startWithNext() { [weak self] _ in
            guard let strongSelf = self else { return }
            
            strongSelf.statusBarItem = NSStatusBar.systemStatusBar().statusItemWithLength(NSSquareStatusItemLength)
            strongSelf.statusBarItem?.menu = strongSelf.buildMenu()
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
        let createIssueFlow = CreateIssueFlow(client: client.value!)
        createIssueFlow.start()
        self.createIssueFlow = createIssueFlow

    }

    func didSelectAbout() {

    }

    func didSelectQuit() {

    }

}
