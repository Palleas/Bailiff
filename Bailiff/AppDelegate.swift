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
import Sparkle

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    private let mainFlow = ApplicationFlow()

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        mainFlow.start()
    }

}



extension AppDelegate {



}