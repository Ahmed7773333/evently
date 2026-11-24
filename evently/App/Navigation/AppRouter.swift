//
//  AppRouter.swift
//  evently
//

import SwiftUI
import Observation

/// A centralized Navigator class inspired by Flutter's Navigator & GoRouter.
@Observable
@MainActor
final class AppRouter: OnboardingCoordinating {
    // MARK: - Navigation State

    /// Root flow (e.g. Onboarding vs Main tabs)
    var root: AppRootFlow

    /// The navigation stack path (bound to NavigationStack)
    var path = NavigationPath()

    /// Currently presented modal sheet
    var activeSheet: AppSheet? = nil

    // MARK: - Dependencies

    private let onboardingRepository: OnboardingRepository

    // MARK: - Init

    init(
        initialRoot: AppRootFlow = .onboarding,
        onboardingRepository: OnboardingRepository = OnboardingRepositoryImpl()
    ) {
        self.root = initialRoot
        self.onboardingRepository = onboardingRepository
    }

    // MARK: - Stack Operations

    /// Pushes a new route onto the current NavigationStack.
    func push(_ route: AppRoute) {
        path.append(route)
    }

    /// Pops the top-most view off the NavigationStack.
    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }

    /// Pops all the way back to the root of the NavigationStack.
    func popToRoot() {
        guard !path.isEmpty else { return }
        path.removeLast(path.count)
    }

    // MARK: - Root Flow Switching

    /// Switches the entire root view (e.g. from Onboarding to Main, or on Logout).
    func switchRoot(to newRoot: AppRootFlow) {
        withAnimation(.easeInOut(duration: 0.35)) {
            activeSheet = nil
            popToRoot()
            root = newRoot
        }
    }

    /// Resets onboarding state and returns the user to the onboarding flow.
    func logout() {
        onboardingRepository.resetOnboarding()
        switchRoot(to: .onboarding)
    }

    // MARK: - Modal Sheets

    /// Presents a modal sheet.
    func presentSheet(_ sheet: AppSheet) {
        activeSheet = sheet
    }

    /// Dismisses the currently presented modal sheet.
    func dismissSheet() {
        activeSheet = nil
    }

    // MARK: - OnboardingCoordinating

    /// Conformance to OnboardingCoordinating protocol used by Clean Architecture ViewModel.
    func didFinishOnboarding() {
        switchRoot(to: .main)
    }
}
