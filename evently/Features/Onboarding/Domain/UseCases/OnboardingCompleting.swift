//
//  OnboardingUsecase.swift
//  evently
//
//  Created by M1 PRO on 10/14/26.
//

import Foundation

protocol CompleteOnboardingUseCaseProtocol: Sendable {
    func execute()
}

struct CompleteOnboardingUseCase: CompleteOnboardingUseCaseProtocol {
    private let repository: OnboardingRepository
    
    init(repository: OnboardingRepository) {
        self.repository = repository
    }
    
    func execute() {
        repository.setOnboardingCompleted()
    }
}
