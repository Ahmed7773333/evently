//
//  eventlyTests.swift
//  eventlyTests
//
//  Created by M1 PRO on 10/14/26.
//

import Foundation
import SwiftUI
import SwiftData
import Testing
@testable import evently

@MainActor
struct eventlyTests {

    @Test func sampleDataSeedsOnceIdempotently() throws {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: evently.Category.self, Event.self, configurations: config)
        let context = container.mainContext

        SampleData.seedIfNeeded(context: context)
        let firstCategories = try context.fetch(FetchDescriptor<evently.Category>())
        let firstEvents = try context.fetch(FetchDescriptor<Event>())

        #expect(firstCategories.count == 5)
        #expect(firstEvents.count == 5)
        #expect(firstEvents.allSatisfy { !$0.location.isEmpty })

        // Calling seedIfNeeded again should not duplicate records
        SampleData.seedIfNeeded(context: context)
        let secondCategories = try context.fetch(FetchDescriptor<evently.Category>())
        let secondEvents = try context.fetch(FetchDescriptor<Event>())

        #expect(secondCategories.count == 5)
        #expect(secondEvents.count == 5)
    }

    @Test func eventCategoryRelationshipPersists() throws {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: evently.Category.self, Event.self, configurations: config)
        let context = container.mainContext

        let music = evently.Category(name: "Music", image: "music.note")
        let concert = Event(
            title: "Jazz Evening",
            eventDescription: "Live quartet performance.",
            location: "Blue Note Hall",
            category: music,
            isFav: true
        )
        context.insert(music)
        context.insert(concert)
        try context.save()

        let fetchedEvents = try context.fetch(FetchDescriptor<Event>())
        #expect(fetchedEvents.count == 1)
        #expect(fetchedEvents.first?.title == "Jazz Evening")
        #expect(fetchedEvents.first?.location == "Blue Note Hall")
        #expect(fetchedEvents.first?.category?.name == "Music")
        #expect(fetchedEvents.first?.isFav == true)
    }

    @Test func onboardingViewModelAdvancesAndCompletes() {
        final class MockCoordinator: OnboardingCoordinating {
            var didFinishCalled = false
            func didFinishOnboarding() { didFinishCalled = true }
        }

        let suiteName = "com.evently.tests.onboarding.\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: suiteName)!
        defer { defaults.removePersistentDomain(forName: suiteName) }

        let repo = OnboardingRepositoryImpl(userDefaults: defaults)
        let coordinator = MockCoordinator()
        let viewModel = OnboardingViewModel(
            getStepsUseCase: GetOnboardingStepsUseCase(repository: repo),
            completeOnboardingUseCase: CompleteOnboardingUseCase(repository: repo),
            coordinator: coordinator
        )

        #expect(viewModel.steps.count == 3)
        #expect(viewModel.currentIndex == 0)
        #expect(!viewModel.isLastStep)

        viewModel.nextButtonTapped()
        #expect(viewModel.currentIndex == 1)

        viewModel.nextButtonTapped()
        #expect(viewModel.currentIndex == 2)
        #expect(viewModel.isLastStep)

        viewModel.nextButtonTapped()
        #expect(coordinator.didFinishCalled)
        #expect(repo.hasCompletedOnboarding())
    }

    @Test func appRouterNavigationAndLogout() {
        let suiteName = "com.evently.tests.router.\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: suiteName)!
        defer { defaults.removePersistentDomain(forName: suiteName) }

        let repo = OnboardingRepositoryImpl(userDefaults: defaults)
        repo.setOnboardingCompleted()

        let router = AppRouter(initialRoot: .main, onboardingRepository: repo)
        let eventID = UUID()

        router.push(.eventDetails(eventID: eventID))
        #expect(router.path.count == 1)

        router.presentSheet(.editEvent(eventID: eventID))
        #expect(router.activeSheet == .editEvent(eventID: eventID))

        router.logout()
        #expect(router.root == .onboarding)
        #expect(router.path.isEmpty)
        #expect(router.activeSheet == nil)
        #expect(!repo.hasCompletedOnboarding())
    }

    @Test func appSettingsPersistsThemeLanguageAndProfile() {
        let suiteName = "com.evently.tests.settings.\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: suiteName)!
        defer { defaults.removePersistentDomain(forName: suiteName) }

        let settings = AppSettings(userDefaults: defaults)
        #expect(!settings.isDarkMode)
        #expect(settings.language == .english)

        settings.toggleTheme()
        settings.toggleLanguage()
        settings.updateProfile(name: "Sara", email: "sara@evently.app")

        // Recreate from same defaults to verify persistence
        let reloaded = AppSettings(userDefaults: defaults)
        #expect(reloaded.isDarkMode)
        #expect(reloaded.language == .arabic)
        #expect(reloaded.userProfile.name == "Sara")
        #expect(reloaded.userProfile.email == "sara@evently.app")
    }
}
