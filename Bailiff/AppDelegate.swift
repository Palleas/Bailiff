//
//  AppDelegate.swift
//  Bailiff
//
//  Created by Romain Pouclet on 2016-04-16.
//  Copyright © 2016 Perfectly-Cooked. All rights reserved.
//

import Cocoa
import Arwing
import ReactiveCocoa
import Result

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {


    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var projectsContainer: NSComboBox!

    @IBOutlet var contentField: NSTextView!
    private var projects = [Project]()

    private var client: Client?

    private let mainFlow = ApplicationFlow()

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        mainFlow.start()
        print(mainFlow)
    }

    func boot() {
        guard let client = client else { return }

        client
            .projects()
            .collect()
            .observeOn(UIScheduler())
            .startWithNext { [weak self] projects in
                self?.projects = projects
                self?.projectsContainer.reloadData()
        }
    }
}

extension AppDelegate: NSComboBoxDataSource {
    func comboBox(aComboBox: NSComboBox, objectValueForItemAtIndex index: Int) -> AnyObject {
        return projects[index].nameWithNamespace
    }

    func numberOfItemsInComboBox(aComboBox: NSComboBox) -> Int {
        return projects.count
    }
}

extension AppDelegate {

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
        client?.createIssue(projects[selectedProject], title: title, description: description).startWithNext { createdIssue in
            print("Created issue #\(createdIssue.iid)")
        }
    }

}