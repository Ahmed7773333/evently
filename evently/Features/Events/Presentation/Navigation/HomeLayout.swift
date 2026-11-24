//
//  HomeLayout.swift
//  evently
//
//  Created by M1 PRO on 10/18/26.
//

import SwiftUI
import SwiftData

struct HomeLayout: View {
    @Environment(AppRouter.self) private var router
    @State private var selectedTab: Int = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(0)

            ListOfFavEvents()
                .tabItem {
                    Label("Favorites", systemImage: "heart.fill")
                }
                .tag(1)

            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
                .tag(2)
        }
        .tabViewStyle(.automatic)
        .tint(AppTheme.primaryBlue)
        .overlay(alignment: .bottomTrailing) {
            if selectedTab != 2 {
                Button {
                    router.presentSheet(.createEvent)
                } label: {
                    Image(systemName: "plus")
                        .font(.title2.bold())
                        .foregroundStyle(.white)
                        .frame(width: 56, height: 56)
                        .background(AppTheme.brandBlue)
                        .clipShape(Circle())
                        .shadow(color: AppTheme.brandBlue.opacity(0.35), radius: 8, x: 0, y: 4)
                }
                .accessibilityLabel("Create Event")
                .padding(.trailing, 20)
                .padding(.bottom, 68)
                .transition(.scale.combined(with: .opacity))
            }
        }
        .animation(.snappy, value: selectedTab)
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Event.self, Category.self, configurations: config)
    SampleData.seedIfNeeded(context: container.mainContext)

    return HomeLayout()
        .environment(AppRouter(initialRoot: .main))
        .environment(AppSettings())
        .modelContainer(container)
}
