//
//  OnboardingWindowController.swift
//  Bailiff
//
//  Created by Romain Pouclet on 2016-04-17.
//  Copyright © 2016 Perfectly-Cooked. All rights reserved.
//

import Cocoa
import ReactiveCocoa
import Result
import Arwing

enum OnboardingError: ErrorType {
    case InvalidEndpoint
    case InvalidToken
}

class OnboardingWindowController: NSWindowController {

    @IBOutlet weak var installationField: NSTextField!
    @IBOutlet weak var privateTokenField: NSTextField!
    @IBOutlet weak var authenticateButton: NSButton!

    let action = Action<(NSURL?, String), Client, OnboardingError> { input in
        guard let url = input.0 else { return SignalProducer(error: OnboardingError.InvalidEndpoint) }

        let client = Client(provider: TokenAuthentication(token: input.1), endpoint: url)
        return SignalProducer(value: client)
    }

    var cocoaAction: CocoaAction?

    override func loadWindow() {
        super.loadWindow()

        action.events.observeNext { print($0) }

        cocoaAction = CocoaAction(action) { [unowned self] input in
            let url = NSURL(string: self.installationField.stringValue)
            return (url, self.privateTokenField.stringValue)
        }

        authenticateButton.target = cocoaAction
        authenticateButton.action = CocoaAction.selector
    }

    override func windowWillLoad() {
        super.windowWillLoad()
        print("lol")
    }
}
