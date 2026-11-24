//
//  AppSettings.swift
//  evently
//

import SwiftUI
import Observation

/// Supported application languages with locale and layout direction metadata.
enum AppLanguage: String, CaseIterable, Identifiable, Sendable {
    case english = "en"
    case arabic = "ar"

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .english: return "English"
        case .arabic: return "عربي"
        }
    }

    var shortCode: String {
        switch self {
        case .english: return "EN"
        case .arabic: return "AR"
        }
    }

    var locale: Locale {
        Locale(identifier: rawValue)
    }

    var layoutDirection: LayoutDirection {
        switch self {
        case .english: return .leftToRight
        case .arabic: return .rightToLeft
        }
    }
}

/// Centralized, persistent application preferences (theme, language, and user profile).
@Observable
@MainActor
final class AppSettings {
    private enum Keys {
        static let isDarkMode = "com.evently.settings.isDarkMode"
        static let language = "com.evently.settings.language"
        static let userProfile = "com.evently.settings.userProfile"
    }

    private let userDefaults: UserDefaults

    var isDarkMode: Bool {
        didSet {
            userDefaults.set(isDarkMode, forKey: Keys.isDarkMode)
        }
    }

    var language: AppLanguage {
        didSet {
            userDefaults.set(language.rawValue, forKey: Keys.language)
        }
    }

    var userProfile: UserProfile {
        didSet {
            if let encoded = try? JSONEncoder().encode(userProfile) {
                userDefaults.set(encoded, forKey: Keys.userProfile)
            }
        }
    }

    var colorScheme: ColorScheme {
        isDarkMode ? .dark : .light
    }

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
        self.isDarkMode = userDefaults.bool(forKey: Keys.isDarkMode)

        if let storedLang = userDefaults.string(forKey: Keys.language),
           let parsedLang = AppLanguage(rawValue: storedLang) {
            self.language = parsedLang
        } else {
            self.language = .english
        }

        if let data = userDefaults.data(forKey: Keys.userProfile),
           let decoded = try? JSONDecoder().decode(UserProfile.self, from: data) {
            self.userProfile = decoded
        } else {
            self.userProfile = .default
        }
    }

    func toggleTheme() {
        withAnimation(.easeInOut(duration: 0.25)) {
            isDarkMode.toggle()
        }
    }

    func toggleLanguage() {
        withAnimation(.easeInOut(duration: 0.25)) {
            language = (language == .english) ? .arabic : .english
        }
    }

    func updateProfile(name: String, email: String) {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else { return }

        userProfile = UserProfile(
            name: trimmedName,
            email: trimmedEmail.isEmpty ? userProfile.email : trimmedEmail,
            avatarImageName: userProfile.avatarImageName
        )
    }
}
