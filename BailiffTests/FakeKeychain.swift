//
//  FakeKeychain.swift
//  Bailiff
//
//  Created by Romain Pouclet on 2016-05-03.
//  Copyright © 2016 Perfectly-Cooked. All rights reserved.
//

import Cocoa

class FakeKeychain: Keychain {
    private var values: [String: String]?

    init(values: [String: String]? = nil) {
        self.values = values
    }

    func load(key key: String) -> String? {
        return values?[key]
    }

    func save(key key: String, value: String) {
        values?[key] = value
    }
}