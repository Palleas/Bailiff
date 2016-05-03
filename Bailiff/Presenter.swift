//
//  Presenter.swift
//  Bailiff
//
//  Created by Romain Pouclet on 2016-05-03.
//  Copyright © 2016 Perfectly-Cooked. All rights reserved.
//

import Foundation
import Cocoa

protocol Presenter {
    func present(controller controller: NSWindowController)
}

class DefaultPresenter: Presenter {

    func present(controller controller: NSWindowController) {
        controller.loadWindow()
        controller.showWindow(nil)
        controller.window?.makeKeyAndOrderFront(self)
    }
    
}