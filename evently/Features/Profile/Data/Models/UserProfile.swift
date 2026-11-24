//
//  UserProfile.swift
//  evently
//

import Foundation

/// Represents the signed-in user's profile information.
struct UserProfile: Codable, Equatable, Sendable {
    var name: String
    var email: String
    var avatarImageName: String

    static let `default` = UserProfile(
        name: "Jack",
        email: "jack@evently.app",
        avatarImageName: "routeLogo"
    )
}
