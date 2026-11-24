//
//  OnboardingNav.swift
//  evently
//
//  Created by M1 PRO on 10/14/26.
//

import Foundation

@MainActor
protocol OnboardingCoordinating: AnyObject {
    func didFinishOnboarding()
}
