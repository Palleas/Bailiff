//
//  CounterPresenter.swift
//  Bailiff
//
//  Created by Romain Pouclet on 2016-05-03.
//  Copyright © 2016 Perfectly-Cooked. All rights reserved.
//

import Cocoa
import ReactiveCocoa

class CounterPresenter: Presenter {
    private(set) var presentationCount = MutableProperty(0)

    func present(controller controller: NSWindowController) {
        presentationCount.value += 1
    }
}
