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

    var cocoaAction: CocoaAction?
    let viewModel: OnboardingViewModel

    init(viewModel: OnboardingViewModel) {
        self.viewModel = viewModel

        super.init(window: nil)

        NSBundle.mainBundle().loadNibNamed("OnboardingWindowController", owner: self, topLevelObjects: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadWindow() {
        super.loadWindow()

        cocoaAction = CocoaAction(viewModel.action) { [unowned self] input in
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
