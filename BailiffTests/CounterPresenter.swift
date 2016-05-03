//
//  CounterPresenter.swift
//  Bailiff
//
//  Created by Romain Pouclet on 2016-05-03.
//  Copyright © 2016 Perfectly-Cooked. All rights reserved.
//

import Cocoa

class CounterPresenter: Presenter {
    private(set) var presentationCount = 0

    func present(controller controller: NSWindowController) {
        presentationCount += 1
    }
}
