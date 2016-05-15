//
//  CreateIssueWindowController.swift
//  Bailiff
//
//  Created by Romain Pouclet on 2016-04-18.
//  Copyright © 2016 Perfectly-Cooked. All rights reserved.
//

import Cocoa
import Arwing
import ReactiveCocoa
import Result

class CreateIssueWindowController: NSWindowController {

    @IBOutlet weak var projectsContainer: NSComboBox!
    @IBOutlet var contentField: NSTextView!
    @IBOutlet weak var createButton: NSButton!

    private var projects = [Project]()
    private let viewModel: CreateIssueViewModel
    private let createAction: CocoaAction

    init(viewModel: CreateIssueViewModel) {
        self.viewModel = viewModel
        self.createAction = CocoaAction(viewModel.createIssueAction, { _ in return () })

        super.init(window: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadWindow() {
        super.loadWindow()

        NSBundle.mainBundle().loadNibNamed("CreateIssueWindowController", owner: self, topLevelObjects: nil)

        self.windowDidLoad()
    }

    override func windowDidLoad() {
        super.windowDidLoad()

        viewModel.projects.producer.startWithNext { [weak self] projects in
            print("Fetched projects: \(projects)")
            self?.projectsContainer.reloadData()
        }

        createButton.target = createAction
        createButton.action = CocoaAction.selector

        viewModel.createIssueAction.events.observeOn(UIScheduler()).observeNext { [weak self] event in
            guard let window = self?.window else { return }

            switch event {
            case .Next(let createdIssue):
                let alert = NSAlert()
                alert.alertStyle = .InformationalAlertStyle
                alert.informativeText = "Issue #\(createdIssue.iid) has been successfully created!"
                alert.addButtonWithTitle("OK")
                alert.beginSheetModalForWindow(window) { _ in
                    self?.close()
                }
            case .Failed(_):
                print("Oops")
            default: break
            }
        }

        viewModel.issueContent <~ contentField.rac_textSignal()
            .toSignalProducer()
            .map { $0 as! String }
            .flatMapError { _ in return SignalProducer<String, NoError>.empty }
    }
}

extension CreateIssueWindowController: NSComboBoxDataSource {
    func comboBox(aComboBox: NSComboBox, objectValueForItemAtIndex index: Int) -> AnyObject {
        return viewModel.projects.value[index].nameWithNamespace
    }

    func numberOfItemsInComboBox(aComboBox: NSComboBox) -> Int {
        return viewModel.projects.value.count
    }
}

extension CreateIssueWindowController: NSComboBoxDelegate {
    func comboBoxSelectionDidChange(notification: NSNotification) {
        viewModel.selectedProjectIndex.value = projectsContainer.indexOfSelectedItem
    }
}
