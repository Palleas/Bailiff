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

class OnboardingViewModel: NSObject {
    
    let action = Action<(NSURL?, String), Client, OnboardingError> { input in
        guard let url = input.0 else { return SignalProducer(error: OnboardingError.InvalidEndpoint) }

        let client = Client(provider: TokenAuthentication(token: input.1), endpoint: url)
        return SignalProducer(value: client)
    }

    
}
