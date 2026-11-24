//
//  HomeTopSection.swift
//  evently
//
//  Created by M1 PRO on 10/18/26.
//

import SwiftUI

struct HomeTopSection: View {
    @Environment(AppSettings.self) private var settings

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 12) {
                Text("Welcome Back ✨")
                    .font(.title2)
                    .fontWeight(.light)
                    .foregroundStyle(.secondary)

                Spacer()

                Button {
                    settings.toggleTheme()
                } label: {
                    Image(systemName: settings.isDarkMode ? "moon.fill" : "sun.max.fill")
                        .font(.title2)
                        .foregroundStyle(AppTheme.primaryBlue)
                        .frame(width: 38, height: 38)
                        .background(AppTheme.surface)
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .stroke(AppTheme.border, lineWidth: 1)
                        )
                }
                .buttonStyle(.plain)
                .accessibilityLabel(settings.isDarkMode ? "Switch to Light Mode" : "Switch to Dark Mode")

                Button {
                    settings.toggleLanguage()
                } label: {
                    Text(settings.language.shortCode)
                        .font(.headline.bold())
                        .padding(.horizontal, 10)
                        .frame(height: 38)
                        .foregroundStyle(.white)
                        .background(AppTheme.brandBlue)
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Switch Language")
            }

            Text(settings.userProfile.name)
                .font(.title)
                .fontWeight(.bold)
                .foregroundStyle(.primary)
        }
        .padding(.horizontal)
        .padding(.top, 8)
    }
}

#Preview {
    HomeTopSection()
        .environment(AppSettings())
}
