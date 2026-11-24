//
//  AppTheme.swift
//  evently
//

import SwiftUI

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

/// Centralized design system tokens matching the Evently Figma palette
/// with full Light Mode and Dark Mode support.
enum AppTheme {
    /// Brand primary blue (#0A389E in Light Mode, brighter vibrant blue in Dark Mode for contrast)
    static let primaryBlue = Color(
        light: Color(red: 0.04, green: 0.22, blue: 0.62),
        dark: Color(red: 0.34, green: 0.55, blue: 0.98)
    )

    /// Brand button fill blue (#0A389E)
    static let brandBlue = Color(red: 0.04, green: 0.22, blue: 0.62)

    /// Main screen background (#F4F7FF in Light Mode, deep slate in Dark Mode)
    static let background = Color(
        light: Color(red: 244 / 255, green: 247 / 255, blue: 255 / 255),
        dark: Color(red: 16 / 255, green: 18 / 255, blue: 28 / 255)
    )

    /// Elevated surface / tile background
    static let surface = Color(
        light: .white,
        dark: Color(red: 26 / 255, green: 29 / 255, blue: 42 / 255)
    )

    /// Soft pill background used on EventCard badges (#F2F5FC in Light Mode)
    static let pillBackground = Color(
        light: Color(red: 0.95, green: 0.96, blue: 0.99),
        dark: Color(red: 26 / 255, green: 30 / 255, blue: 46 / 255).opacity(0.92)
    )

    /// Subtle stroke border
    static let border = Color(
        light: Color(red: 0.04, green: 0.22, blue: 0.62).opacity(0.20),
        dark: Color.white.opacity(0.14)
    )
}

private extension Color {
    init(light: Color, dark: Color) {
        #if canImport(UIKit)
        self.init(UIColor { traits in
            traits.userInterfaceStyle == .dark ? UIColor(dark) : UIColor(light)
        })
        #elseif canImport(AppKit)
        self.init(NSColor(name: nil) { appearance in
            appearance.bestMatch(from: [.darkAqua, .aqua]) == .darkAqua ? NSColor(dark) : NSColor(light)
        })
        #else
        self = light
        #endif
    }
}
