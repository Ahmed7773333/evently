//
//  OnboardingRepoImpl.swift
//  evently
//
//  Created by M1 PRO on 10/14/26.
//

import Foundation

final class OnboardingRepositoryImpl: OnboardingRepository, @unchecked Sendable {
    private let userDefaults: UserDefaults
    private let completedKey = "com.app.hasCompletedOnboarding"

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    func fetchOnboardingSteps() -> [OnboardingStep] {
        // These keys match Localizable.xcstrings for English & Arabic
        return [
            OnboardingStep(
                id: 0,
                titleKey: "onboarding.step1.title",
                subtitleKey: "onboarding.step1.subtitle",
                symbolName: "calendar.badge.clock",
                accentColorToken: "BrandPrimary"
            ),
            OnboardingStep(
                id: 1,
                titleKey: "onboarding.step2.title",
                subtitleKey: "onboarding.step2.subtitle",
                symbolName: "star.bubble.fill",
                accentColorToken: "BrandSecondary"
            ),
            OnboardingStep(
                id: 2,
                titleKey: "onboarding.step3.title",
                subtitleKey: "onboarding.step3.subtitle",
                symbolName: "bell.badge.fill",
                accentColorToken: "BrandTertiary"
            )
        ]
    }

    func hasCompletedOnboarding() -> Bool {
        userDefaults.bool(forKey: completedKey)
    }

    func setOnboardingCompleted() {
        userDefaults.set(true, forKey: completedKey)
    }

    func resetOnboarding() {
        userDefaults.set(false, forKey: completedKey)
    }
}
