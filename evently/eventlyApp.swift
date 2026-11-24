//
//  eventlyApp.swift
//  evently
//
//  Created by M1 PRO on 10/14/26.
//

import SwiftUI
import SwiftData

@main
struct eventlyApp: App {
    // MARK: - SwiftData Container
    let sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Category.self,
            Event.self,
            Item.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            let container = try ModelContainer(for: schema, configurations: [modelConfiguration])
            // Pre-seed sample categories and events for first-time launch
            SampleData.seedIfNeeded(context: container.mainContext)
            return container
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    // MARK: - App State
    @State private var router: AppRouter
    @State private var settings: AppSettings

    init() {
        let repo = OnboardingRepositoryImpl()
        let hasCompleted = repo.hasCompletedOnboarding()
        let initialRoot: AppRootFlow = hasCompleted ? .main : .onboarding
        _router = State(initialValue: AppRouter(initialRoot: initialRoot, onboardingRepository: repo))
        _settings = State(initialValue: AppSettings())
    }

    // MARK: - Body
    var body: some Scene {
        WindowGroup {
            AppRootView()
                .environment(router)
                .environment(settings)
                .preferredColorScheme(settings.colorScheme)
                .environment(\.locale, settings.language.locale)
                .environment(\.layoutDirection, settings.language.layoutDirection)
        }
        .modelContainer(sharedModelContainer)
    }
}
