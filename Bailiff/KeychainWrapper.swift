//
//  KeychainWrapper.swift
//  Bailiff
//
//  Created by Romain Pouclet on 2016-05-02.
//  Copyright © 2016 Perfectly-Cooked. All rights reserved.
//

import Foundation
import KeychainSwift

protocol Keychain {
    func save(key key: String, value: String)
    func load(key key: String) -> String?
}

class KeychainSwiftWrapper: Keychain {

    private let keychain: KeychainSwift

    init(keychain: KeychainSwift) {
        self.keychain = keychain
    }

    func save(key key: String, value: String) {
        keychain.set(value, forKey: key)
    }

    func load(key key: String) -> String? {
        return keychain.get(key)
    }
}