//
//  AppRootView.swift
//  evently
//

import SwiftUI
import SwiftData

struct AppRootView: View {
    @Environment(AppRouter.self) private var router

    var body: some View {
        @Bindable var bindableRouter = router

        Group {
            switch router.root {
            case .onboarding:
                OnboardingView.build(coordinator: router)

            case .main:
                NavigationStack(path: $bindableRouter.path) {
                    HomeLayout()
                        .navigationDestination(for: AppRoute.self) { route in
                            destinationView(for: route)
                        }
                }
                .sheet(item: $bindableRouter.activeSheet) { sheet in
                    sheetView(for: sheet)
                }
            }
        }
    }

    // MARK: - Route Resolvers

    @ViewBuilder
    private func destinationView(for route: AppRoute) -> some View {
        switch route {
        case .eventDetails(let eventID):
            EventDetailsView(eventID: eventID)
        case .createEvent:
            CreateEditEventView(mode: .create)
        case .editEvent(let eventID):
            CreateEditEventView(mode: .edit(eventID: eventID))
        }
    }

    @ViewBuilder
    private func sheetView(for sheet: AppSheet) -> some View {
        switch sheet {
        case .createEvent:
            CreateEditEventView(mode: .create)
        case .editEvent(let eventID):
            CreateEditEventView(mode: .edit(eventID: eventID))
        case .editProfile:
            EditProfileView()
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Event.self, Category.self, configurations: config)
    SampleData.seedIfNeeded(context: container.mainContext)

    return AppRootView()
        .environment(AppRouter(initialRoot: .main))
        .environment(AppSettings())
        .modelContainer(container)
}
