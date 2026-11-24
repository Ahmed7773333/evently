//
//  OnboardingViewmodel.swift
//  evently
//
//  Created by M1 PRO on 10/14/26.
//

import Foundation
import Observation

@MainActor
@Observable
final class OnboardingViewModel {
        // MARK: - State
    private(set) var steps: [OnboardingStep] = []
    var currentStepID: Int? = 0
    
        // MARK: - Dependencies
    private let getStepsUseCase: GetOnboardingStepsUseCaseProtocol
    private let completeOnboardingUseCase: CompleteOnboardingUseCaseProtocol
    private weak var coordinator: OnboardingCoordinating?
    
        // MARK: - Computed Properties
    var currentIndex: Int {
        currentStepID ?? 0
    }
    
    var isLastStep: Bool {
        guard !steps.isEmpty else { return false }
        return currentIndex == steps.count - 1
    }
    
        // MARK: - Init (Constructor Injection)
    init(
        getStepsUseCase: GetOnboardingStepsUseCaseProtocol,
        completeOnboardingUseCase: CompleteOnboardingUseCaseProtocol,
        coordinator: OnboardingCoordinating? = nil
    ) {
        self.getStepsUseCase = getStepsUseCase
        self.completeOnboardingUseCase = completeOnboardingUseCase
        self.coordinator = coordinator
        loadSteps()
    }
    
        // MARK: - Intents (User Actions)
    private func loadSteps() {
        steps = getStepsUseCase.execute()
        currentStepID = steps.first?.id
    }
    
    func nextButtonTapped() {
        if isLastStep {
            completeOnboarding()
        } else {
            currentStepID = currentIndex + 1
        }
    }
    
    func skipButtonTapped() {
        completeOnboarding()
    }
    
    private func completeOnboarding() {
        completeOnboardingUseCase.execute()
        coordinator?.didFinishOnboarding()
    }
}
