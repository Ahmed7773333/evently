//
//  OnboardingRepo.swift
//  evently
//
//  Created by M1 PRO on 10/14/26.
//

import Foundation

protocol OnboardingRepository: Sendable {
    func fetchOnboardingSteps() -> [OnboardingStep]
    func hasCompletedOnboarding() -> Bool
    func setOnboardingCompleted()
    func resetOnboarding()
}
