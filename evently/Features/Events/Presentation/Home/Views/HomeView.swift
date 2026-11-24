//
//  HomeView.swift
//  evently
//
//  Created by M1 PRO on 10/18/26.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @State private var selectedCategory: Category? = nil
    @Query(sort: \Category.name) private var allCategories: [Category]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HomeTopSection()
            CategoriesBar(categories: allCategories, selectedCategory: $selectedCategory)
            ListOfEvents(selectedCategory: selectedCategory)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppTheme.background.ignoresSafeArea())
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Event.self, Category.self, configurations: config)
    SampleData.seedIfNeeded(context: container.mainContext)

    return HomeView()
        .environment(AppRouter(initialRoot: .main))
        .environment(AppSettings())
        .modelContainer(container)
}
