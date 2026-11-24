//
//  ListOfFavEvents.swift
//  evently
//
//  Created by M1 PRO on 10/18/26.
//

import SwiftUI
import SwiftData

struct ListOfFavEvents: View {
    @Environment(AppRouter.self) private var router
    @Environment(\.modelContext) private var modelContext

    @Query(sort: \Event.date, order: .forward) private var events: [Event]
    @State private var searchValue = ""

    private var favoriteEvents: [Event] {
        events.filter { $0.isFav }
    }

    private var filteredEvents: [Event] {
        let query = searchValue.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else { return favoriteEvents }

        return favoriteEvents.filter { event in
            event.title.localizedCaseInsensitiveContains(query)
            || event.eventDescription.localizedCaseInsensitiveContains(query)
            || event.location.localizedCaseInsensitiveContains(query)
            || (event.category?.name.localizedCaseInsensitiveContains(query) ?? false)
        }
    }

    private var suggestedCategoryNames: [String] {
        let names = favoriteEvents.compactMap { $0.category?.name }
        return Array(Set(names)).sorted()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Favorites")
                .font(.largeTitle.bold())
                .padding(.horizontal, 16)
                .padding(.top, 8)

            SearchBar(text: $searchValue, placeholder: "Search events...")
                .padding(.horizontal, 16)

            if searchValue.isEmpty, !suggestedCategoryNames.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(suggestedCategoryNames, id: \.self) { suggestion in
                            Button {
                                withAnimation(.snappy) {
                                    searchValue = suggestion
                                }
                            } label: {
                                Text(suggestion)
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(AppTheme.primaryBlue)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(AppTheme.surface)
                                    .clipShape(Capsule())
                                    .overlay(
                                        Capsule()
                                            .stroke(AppTheme.border, lineWidth: 1)
                                    )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, 16)
                }
            }

            if favoriteEvents.isEmpty {
                ContentUnavailableView(
                    "No Favorite Events",
                    systemImage: "heart.slash",
                    description: Text("Tap the heart on any event to save it here.")
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if filteredEvents.isEmpty {
                ContentUnavailableView.search(text: searchValue)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List {
                    ForEach(filteredEvents) { event in
                        EventCard(event: event)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                router.push(.eventDetails(eventID: event.id))
                            }
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button {
                                    withAnimation(.snappy) {
                                        event.isFav = false
                                        try? modelContext.save()
                                    }
                                } label: {
                                    Label("Remove", systemImage: "heart.slash")
                                }
                                .tint(.orange)
                            }
                            .listRowSeparator(.hidden)
                            .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                            .listRowBackground(Color.clear)
                    }

                    Color.clear
                        .frame(height: 80)
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppTheme.background.ignoresSafeArea())
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Event.self, Category.self, configurations: config)
    SampleData.seedIfNeeded(context: container.mainContext)

    return ListOfFavEvents()
        .environment(AppRouter(initialRoot: .main))
        .modelContainer(container)
}
