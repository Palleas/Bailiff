//
//  OnboardingFlow.swift
//  Bailiff
//
//  Created by Romain Pouclet on 2016-04-23.
//  Copyright © 2016 Perfectly-Cooked. All rights reserved.
//

import Cocoa
import ReactiveCocoa
import Arwing
import Result
import KeychainSwift

class OnboardingFlow: NSObject {
    static let PrivateKeyStorageKey = "com.perfectly-cooked.bailiff.PrivateKeyStorageKey"
    static let EndpointStorageKey = "com.perfectly-cooked.bailiff.EndpointStorageKey"

    private let onboardingWindowController: OnboardingWindowController
    private let onboardingViewModel: OnboardingViewModel

    private let keychain: Keychain
    private let presenter: Presenter

    init(keychain: Keychain, presenter: Presenter, onboardingViewModel: OnboardingViewModel) {
        self.keychain = keychain
        self.presenter = presenter
        self.onboardingViewModel = onboardingViewModel
        
        // Create the window controller
        self.onboardingWindowController = OnboardingWindowController(viewModel: onboardingViewModel)

        super.init()
    }

    func prepare() -> SignalProducer<Client, NoError> {
        if let endPointString = keychain.load(key: OnboardingFlow.EndpointStorageKey), let endpoint = NSURL(string: endPointString), let token = keychain.load(key: OnboardingFlow.PrivateKeyStorageKey) {
            let client = Client(provider: TokenAuthentication(token: token), endpoint: endpoint)
            return SignalProducer(value: client)
        }

        presenter.present(controller: onboardingWindowController)

        return SignalProducer(signal: onboardingViewModel.action.values)
            .on(next: saveCredentials)
    }

    func saveCredentials(client: Client) {
        print("Saving credentials")
        
        // Store token
        let keychain = KeychainSwift()
        keychain.set(client.provider.rawToken, forKey: OnboardingFlow.PrivateKeyStorageKey)
        // Store endpoint
        keychain.set(client.endpoint.absoluteString, forKey: OnboardingFlow.EndpointStorageKey)
    }

}
