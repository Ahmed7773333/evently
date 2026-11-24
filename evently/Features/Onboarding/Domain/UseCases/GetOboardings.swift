//
//  GetOboardings.swift
//  evently
//
//  Created by M1 PRO on 10/14/26.
//

import Foundation

protocol GetOnboardingStepsUseCaseProtocol: Sendable {
    func execute() -> [OnboardingStep]
}

struct GetOnboardingStepsUseCase: GetOnboardingStepsUseCaseProtocol {
    private let repository: OnboardingRepository
    
    init(repository: OnboardingRepository) {
        self.repository = repository
    }
    
    func execute() -> [OnboardingStep] {
        repository.fetchOnboardingSteps()
    }
}
