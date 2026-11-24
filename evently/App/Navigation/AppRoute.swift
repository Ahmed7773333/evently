//
//  AppRoute.swift
//  evently
//

import Foundation

/// Defines top-level flows (similar to route groups or root redirection in Flutter/GoRouter)
enum AppRootFlow: Equatable {
    case onboarding
    case main
}

/// Pushable destinations on the NavigationStack (equivalent to Flutter named routes)
enum AppRoute: Hashable {
    case eventDetails(eventID: UUID)
    case createEvent
    case editEvent(eventID: UUID)
}

/// Modal / Bottom Sheet destinations (equivalent to Flutter showModalBottomSheet)
enum AppSheet: Identifiable, Equatable {
    case createEvent
    case editEvent(eventID: UUID)
    case editProfile

    var id: String {
        switch self {
        case .createEvent:
            return "createEvent"
        case .editEvent(let eventID):
            return "editEvent-\(eventID.uuidString)"
        case .editProfile:
            return "editProfile"
        }
    }
}
