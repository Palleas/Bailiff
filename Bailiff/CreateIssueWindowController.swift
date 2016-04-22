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

class CreateIssueWindowController: NSWindowController {

    @IBOutlet weak var projectsContainer: NSComboBox!
    @IBOutlet var contentField: NSTextView!

    private var projects = [Project]()
    private let client: Client

    init(client: Client) {
        self.client = client

        super.init(window: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadWindow() {
        super.loadWindow()

        NSBundle.mainBundle().loadNibNamed("CreateIssueWindowController", owner: self, topLevelObjects: nil)
    }

    @IBAction func createIssue(sender: AnyObject) {
        let selectedProject = projectsContainer.indexOfSelectedItem
        guard (0..<projects.count).contains(selectedProject) else {
            print("No project selected: abort")
            return
        }

        guard let content = contentField.string else {
            print("No content in field: abort")
            return
        }

        let lines = content.characters.split { $0 == "\n" }.map(String.init)
        let title = lines.first!
        let description = lines[1..<lines.count].joinWithSeparator("\n")

        print("title: \(title)")
        print("description: \(description)")
        client.createIssue(projects[selectedProject], title: title, description: description).startWithNext { createdIssue in
            print("Created issue #\(createdIssue.iid)")
        }
    }
}

extension CreateIssueWindowController: NSComboBoxDataSource {
    func comboBox(aComboBox: NSComboBox, objectValueForItemAtIndex index: Int) -> AnyObject {
        return projects[index].nameWithNamespace
    }

    func numberOfItemsInComboBox(aComboBox: NSComboBox) -> Int {
        return projects.count
    }
}
