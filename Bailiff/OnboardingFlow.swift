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
    private let onboardingWindowController: OnboardingWindowController
    private let onboardingViewModel = OnboardingViewModel()

    override init() {
        self.onboardingWindowController = OnboardingWindowController(viewModel: onboardingViewModel)

        super.init()
    }

    func prepare() -> SignalProducer<Client, NoError> {
        let keychain = KeychainSwift()
        if let endPointString = keychain.get(ApplicationFlow.EndpointStorageKey), let endpoint = NSURL(string: endPointString), let token = keychain.get(ApplicationFlow.PrivateKeyStorageKey) {
            let client = Client(provider: TokenAuthentication(token: token), endpoint: endpoint)
            return SignalProducer(value: client)
        }

        onboardingWindowController.loadWindow()
        onboardingWindowController.showWindow(nil)
        onboardingWindowController.window?.makeKeyAndOrderFront(self)

        return SignalProducer(signal: onboardingViewModel.action.values)
            .on(next: saveCredentials)
    }

    func saveCredentials(client: Client) {
        print("Saving credentials")
        
        // Store token
        let keychain = KeychainSwift()
        keychain.set(client.provider.rawToken, forKey: ApplicationFlow.PrivateKeyStorageKey)
        // Store endpoint
        keychain.set(client.endpoint.absoluteString, forKey: ApplicationFlow.EndpointStorageKey)
    }

}
