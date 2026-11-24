//
//  ProfileView.swift
//  evently
//

import SwiftUI
import SwiftData

struct ProfileView: View {
    @Environment(AppSettings.self) private var settings
    @Environment(AppRouter.self) private var router

    @Query private var events: [Event]
    @Query private var categories: [Category]

    @State private var showLogoutConfirmation = false

    private var favoritesCount: Int {
        events.filter { $0.isFav }.count
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header Avatar & User Info
                VStack(spacing: 10) {
                    Image(settings.userProfile.avatarImageName)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(AppTheme.primaryBlue, lineWidth: 3)
                        )
                        .shadow(color: AppTheme.brandBlue.opacity(0.2), radius: 10, x: 0, y: 4)

                    Text(settings.userProfile.name)
                        .font(.title.bold())
                        .foregroundStyle(.primary)

                    Text(settings.userProfile.email)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding(.top, 20)

                // Live Stats Bar
                HStack(spacing: 12) {
                    statCard(value: "\(events.count)", label: "Events", icon: "calendar")
                    statCard(value: "\(favoritesCount)", label: "Favorites", icon: "heart.fill")
                    statCard(value: "\(categories.count)", label: "Categories", icon: "square.grid.2x2")
                }

                // Settings & Account Actions
                VStack(spacing: 12) {
                    ProfileTile(
                        title: "Edit Profile",
                        subtitle: settings.userProfile.name,
                        icon: "person.crop.circle"
                    ) {
                        router.presentSheet(.editProfile)
                    }

                    ProfileTile(
                        title: settings.isDarkMode ? "Dark Mode" : "Light Mode",
                        subtitle: settings.isDarkMode ? "Switch to Light Mode" : "Switch to Dark Mode",
                        icon: settings.isDarkMode ? "moon.fill" : "sun.max.fill"
                    ) {
                        settings.toggleTheme()
                    }

                    ProfileTile(
                        title: LocalizedStringKey(settings.language.displayName),
                        subtitle: settings.language == .english ? "Switch to العربية" : "Switch to English",
                        icon: "globe"
                    ) {
                        settings.toggleLanguage()
                    }

                    ProfileTile(
                        title: "Logout",
                        icon: "iphone.and.arrow.right.outward",
                        isDestructive: true
                    ) {
                        showLogoutConfirmation = true
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 32)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppTheme.background.ignoresSafeArea())
        .alert("Logout?", isPresented: $showLogoutConfirmation) {
            Button("Logout", role: .destructive) {
                router.logout()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("You will be returned to the onboarding screen.")
        }
    }

    private func statCard(value: String, label: LocalizedStringKey, icon: String) -> some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.headline)
                .foregroundStyle(AppTheme.primaryBlue)

            Text(value)
                .font(.title2.bold())
                .foregroundStyle(.primary)

            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(AppTheme.surface)
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(AppTheme.border, lineWidth: 1)
        )
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Event.self, Category.self, configurations: config)
    SampleData.seedIfNeeded(context: container.mainContext)

    return ProfileView()
        .environment(AppSettings())
        .environment(AppRouter(initialRoot: .main))
        .modelContainer(container)
}
