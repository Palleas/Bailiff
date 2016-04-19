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

class CreateIssueFlow: NSObject {
    private let client: Client

    init(client: Client) {
        self.client = client
    }

    func start() {
        print("Starting Create Issue Flow")
    }
}
