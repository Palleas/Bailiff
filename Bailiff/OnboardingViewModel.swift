//
//  OnboardingViewModel.swift
//  Bailiff
//
//  Created by Romain Pouclet on 2016-04-18.
//  Copyright © 2016 Perfectly-Cooked. All rights reserved.
//

import Cocoa
import ReactiveCocoa
import Arwing
import KeychainSwift

class OnboardingViewModel: NSObject {

    let action = Action<(NSURL?, String), Client, OnboardingError> { (url, privateKey) in
        guard let url = url else { return SignalProducer(error: OnboardingError.InvalidEndpoint) }

        return SignalProducer(value: Client(provider: TokenAuthentication(token: privateKey), endpoint: url))
    }

}
