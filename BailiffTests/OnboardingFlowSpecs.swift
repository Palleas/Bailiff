//
//  OnboardingFlowSpecs.swift
//  Bailiff
//
//  Created by Romain Pouclet on 2016-05-02.
//  Copyright © 2016 Perfectly-Cooked. All rights reserved.
//

import XCTest
import Quick
import Nimble

class OnboardingFlowSpecs: QuickSpec {
    override func spec() {
        describe("The Onboarding Flow") {
            var presenter: CounterPresenter!

            beforeEach() {
                presenter = CounterPresenter()
            }

            context("When the user doesn't have a token") {

            }

            context("When the user already have a token") {
                it("should create a client") {
                    let fakeKeychain = FakeKeychain(values: [OnboardingFlow.PrivateKeyStorageKey: "my-private-key", OnboardingFlow.EndpointStorageKey: "http://gitlab.company.com"])

                    let flow = OnboardingFlow(keychain: fakeKeychain, presenter: presenter, onboardingViewModel: OnboardingViewModel())

                    waitUntil() { done in
                        flow.prepare().startWithNext({ (client) in
                            // It should create a client
                            expect(client).toNot(beNil())
                            // An it should not have presented a window
                            // as it's invisible to the user
                            expect(presenter.presentationCount.value).to(equal(0))

                            done()
                        })
                    }
                }
            }

            context("When the user doesn't have any stored credentials") {
                it("should present the onboarding window to the user and result with a new client") {
                    let fakeKeychain = FakeKeychain()
                    let onboardingViewModel = OnboardingViewModel()

                    let flow = OnboardingFlow(keychain: fakeKeychain, presenter: presenter, onboardingViewModel: onboardingViewModel)

                    waitUntil() { done in
                        flow.prepare().startWithNext({ (client) in
                            expect(client.provider.rawToken).to(equal("private-key"))
                            expect(client.endpoint).to(equal(NSURL(string: "http://gitlab.company.com")))

                            // it should have presented a window
                            // as it's invisible to the user
                            expect(presenter.presentationCount.value).to(equal(1))

                            done()
                        })

                        onboardingViewModel.action.apply((NSURL(string: "http://gitlab.company.com"), "private-key")).start()
                    }
                }
            }

            context("When the user has a token but no endpoint") {
                it("should present the onboarding window to the user") {
                    let fakeKeychain = FakeKeychain(values: [OnboardingFlow.PrivateKeyStorageKey: "my-private-key"])
                    let onboardingViewModel = OnboardingViewModel()

                    let flow = OnboardingFlow(keychain: fakeKeychain, presenter: presenter, onboardingViewModel: onboardingViewModel)

                    waitUntil() { done in
                        flow.prepare().startWithNext({ (client) in
                            // An it should have presented a window
                            // as it's invisible to the user
                            expect(presenter.presentationCount.value).to(equal(1))

                            done()
                        })

                        onboardingViewModel.action.apply((NSURL(string: "http://gitlab.company.com"), "private-key")).start()
                    }
                }
            }

            context("When the user has an endpoint but no token") {
                it("should present the onboarding window to the user") {
                    let fakeKeychain = FakeKeychain(values: [OnboardingFlow.EndpointStorageKey: "http://gitlab.company.com"])
                    let onboardingViewModel = OnboardingViewModel()

                    let flow = OnboardingFlow(keychain: fakeKeychain, presenter: presenter, onboardingViewModel: onboardingViewModel)

                    waitUntil() { done in
                        flow.prepare().startWithNext({ (client) in
                            // An it should have presented a window
                            // as it's invisible to the user
                            expect(presenter.presentationCount.value).to(equal(1))

                            done()
                        })

                        onboardingViewModel.action.apply((NSURL(string: "http://gitlab.company.com"), "private-key")).start()
                    }
                }
            }
        }
    }

}
